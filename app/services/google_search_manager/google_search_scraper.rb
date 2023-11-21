# frozen_string_literal: true

module GoogleSearchManager
  class GoogleSearchScraper < ApplicationService
    def initialize(keyword, html)
      @keyword = keyword
      @html = html
    end

    def call
      doc = Nokogiri::HTML5.parse(@html)

      search_result = SearchResult.build(keyword: @keyword)
      search_result.adwords_count = doc.css('.ad_cclk').size
      search_result.links_count = doc.css('a').size
      search_result.total_results = doc.at('div#result-stats')&.text || ''
      search_result.html_code = @html

      search_result.save
    end
  end
end

