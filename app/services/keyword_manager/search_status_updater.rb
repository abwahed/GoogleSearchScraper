# frozen_string_literal: true

module KeywordManager
  class SearchStatusUpdater < ApplicationService
    def initialize(keyword, status)
      @keyword = keyword
      @status = status
    end

    def call
      @keyword.update(search_status: @status)
      GoogleSearchManager::GoogleSearchNotifier.call(@keyword)
    end
  end
end
