# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user
  has_one :search_result, dependent: :destroy

  validates :name, presence: true

  after_create_commit :initiate_scraping

  private

  def initiate_scraping
    WebScrapingJob.set(wait: rand(10..50).seconds).perform_later(self)
  end
end
