# frozen_string_literal: true

class SearchResultsController < ApplicationController
  before_action :set_search_result
  def show; end

  private

  def set_search_result
    @search_result = @current_user.search_results.find_by(id: params[:id])
  end
end
