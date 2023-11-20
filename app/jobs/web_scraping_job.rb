# frozen_string_literal: true

require 'selenium-webdriver'
class WebScrapingJob < ApplicationJob
  queue_as :default

  def perform(keyword)
    notify_searching(keyword)
    url = "https://www.google.com/search?q=#{CGI.escape(keyword.name)}"

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-software-rasterizer')

    driver = Selenium::WebDriver.for(:chrome, options:)
    begin
      driver.get(url)
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until { driver.find_element(css: 'div#result-stats') }

      html = driver.page_source
      parse_search_results(keyword, html)
      notify_completed(keyword)
    rescue StandardError => e
      notify_failed(keyword)
      retry_job(wait: 30.seconds)
    ensure
      driver.quit
    end
  end

  private

  def parse_search_results(keyword, html)
    doc = Nokogiri::HTML5.parse(html)

    search_result = SearchResult.build(keyword:)
    search_result.adwords_count = doc.css('.ad_cclk').size
    search_result.links_count = doc.css('a').size
    search_result.total_results = doc.at('div#result-stats')&.text || ''
    search_result.html_code = html

    search_result.save
    search_result
  end

  def notify_searching(keyword)
    Turbo::StreamsChannel.broadcast_replace_to(
      [keyword.user, :data_set],
      target: "data-container-#{keyword.id}",
      partial: 'keywords/keyword',
      locals: { keyword:, status: 'searching' }
    )
  end

  def notify_completed(keyword)
    Turbo::StreamsChannel.broadcast_replace_to(
      [keyword.user, :data_set],
      target: "data-container-#{keyword.id}",
      partial: 'keywords/keyword',
      locals: { keyword:, status: 'complete' }
    )
  end

  def notify_failed(keyword)
    Turbo::StreamsChannel.broadcast_replace_to(
      [keyword.user, :data_set],
      target: "data-container-#{keyword.id}",
      partial: 'keywords/keyword',
      locals: { keyword:, status: 'failed' }
    )
  end

  def notify_retrying(keyword)
    Turbo::StreamsChannel.broadcast_replace_to(
      [keyword.user, :data_set],
      target: "data-container-#{keyword.id}",
      partial: 'keywords/keyword',
      locals: { keyword:, status: 'retrying' }
    )
  end
end
