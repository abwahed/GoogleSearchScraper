# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  before_action :set_keyword, only: %i[search_result]
  def new; end

  def create
    if keyword_params[:file].present?
      csv_data = keyword_params[:file].read
      keywords_array = CSV.parse(csv_data, headers: false).flatten

      keywords_array.each do |keyword|
        @current_user.keywords.create(name: keyword)
      end

      redirect_to keywords_path, notice: 'Keywords were successfully created.'
    else
      redirect_to new_keyword_path, alert: 'Please upload a valid CSV file.'
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
