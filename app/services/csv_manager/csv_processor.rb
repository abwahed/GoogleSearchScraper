# frozen_string_literal: true

require 'csv'

module CsvManager
  class CsvProcessor
    include ActiveModel::Validations

    MAX_KEYWORDS_ALLOWED = 100

    attr_accessor :file, :keywords_array

    validate :validate_max_keywords

    def initialize(file)
      @file = file
      @keywords_array = read_and_parse_csv
    end

    private

    def read_and_parse_csv
      return [] unless file.present?

      csv_data = file.read
      CSV.parse(csv_data, headers: false).flatten
    end

    def validate_max_keywords
      return if keywords_array.size < MAX_KEYWORDS_ALLOWED

      errors.add(:base, "You can upload a maximum of #{MAX_KEYWORDS_ALLOWED} keywords.")
    end
  end
end
