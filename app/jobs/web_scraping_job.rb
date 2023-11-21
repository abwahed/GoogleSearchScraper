# frozen_string_literal: true

class WebScrapingJob < ApplicationJob
  queue_as :default

  def perform(keyword)
    KeywordManager::SearchStatusUpdater.call(keyword, 'searching')
    html = GoogleSearchManager::GoogleSearchFetcher.call(keyword)
    GoogleSearchManager::GoogleSearchScraper.call(keyword, html)
    KeywordManager::SearchStatusUpdater.call(keyword, 'complete')
  rescue StandardError => e
    KeywordManager::SearchStatusUpdater.call(keyword, 'failed')
    retry_job(wait: 20.seconds)
    KeywordManager::SearchStatusUpdater.call(keyword, 'retrying')
  end
end
