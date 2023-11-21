# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user
  has_one :search_result, dependent: :destroy

  enum :search_status, {
    not_started: 0,
    searching: 1,
    complete: 2,
    failed: 3,
    retrying: 4
  }

  validates :name, presence: true
  validates :search_status, presence: true, inclusion: { in: search_statuses.keys }

  after_create_commit :initiate_scraping

  private

  def initiate_scraping
    WebScrapingJob.set(wait: rand(5..20).seconds).perform_later(self)
  end
end
