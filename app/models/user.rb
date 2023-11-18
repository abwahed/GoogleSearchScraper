# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :keywords, dependent: :delete_all
  has_many :search_results, through: :keywords, class_name: 'SearchResult'

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
end
