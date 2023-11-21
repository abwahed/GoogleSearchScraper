# frozen_string_literal: true

class KeywordsController < ApplicationController
  before_action :set_keyword, only: %i[search_result]

  def new; end

  def create
    if keyword_params[:file].present? && keyword_params[:file].content_type == 'text/csv'
      csv_processor = CsvManager::CsvProcessor.new(keyword_params[:file])
      if csv_processor.valid?
        csv_processor.keywords_array.each do |keyword|
          @current_user.keywords.create(name: keyword)
        end
        redirect_to keywords_path, notice: 'Keywords were successfully created.'
        return
      end

      render turbo_stream: turbo_stream.replace(
        'keyword_form',
        partial: 'keywords/form', locals: { error: csv_processor.errors.full_messages.join(', ') }
      )
    else
      render turbo_stream: turbo_stream.replace(
        'keyword_form',
        partial: 'keywords/form', locals: { error: 'Please upload a valid CSV file' }
      )
    end
  end

  def index
    # pagination was not mentioned in the requirement, so keeping the last 100 records
    @keywords = @current_user.keywords.order(id: :desc).limit(100).includes(:search_result)
  end

  def search_result
    @search_result = @keyword.search_result
  end

  private

  def keyword_params
    params.require(:keywords).permit(:file)
  end

  def set_keyword
    @keyword = @current_user.keywords.find_by(id: params[:id])
  end
end
