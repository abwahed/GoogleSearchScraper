# frozen_string_literal: true

class SearchResult < ApplicationRecord
  belongs_to :keyword
  has_one :user, through: :keyword

  validates :adwords_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :links_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_results, presence: true
  validates :html_code, presence: true
end
