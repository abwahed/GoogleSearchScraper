# frozen_string_literal: true

require 'selenium-webdriver'

module GoogleSearchManager
  class GoogleSearchFetcher < ApplicationService
    def initialize(keyword)
      @keyword = keyword
    end

    def call
      url = "https://www.google.com/search?q=#{CGI.escape(@keyword.name)}"
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
      rescue
        KeywordManager::SearchStatusUpdater.call(@keyword, 'failed')
      ensure
        driver.quit
      end

      html
    end
  end
end
