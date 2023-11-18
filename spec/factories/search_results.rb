# frozen_string_literal: true

FactoryBot.define do
  factory :search_result do
    adwords_count { 5 }
    links_count { 10 }
    total_results { 'About 21,600,000 results (0.42 seconds)' }
    html_code { '<html><body><p>Hello, World!</p></body></html>' }
    keyword
  end
end
