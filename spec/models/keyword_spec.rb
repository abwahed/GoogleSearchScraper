# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'associations' do
    it 'should have one search results' do
      keyword = create(:keyword)
      search = create(:search_result, keyword:)
      expect(keyword.search_result).to eq(search)
    end

    it 'should belong to a user' do
      user = create(:user)
      keyword = create(:keyword, user:)
      expect(keyword.user).to eq(user)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      keyword = build(:keyword)
      expect(keyword).to be_valid
    end

    it 'is not valid without a name' do
      keyword = build(:keyword, name: nil)
      expect(keyword).to_not be_valid
    end

    it 'is not valid without a search status' do
      keyword = build(:keyword, search_status: nil)
      expect(keyword).to_not be_valid
    end
  end

  describe 'callbacks' do
    describe 'after_create_commit' do
      it 'calls initiate_scraping after create' do
        keyword = build(:keyword)

        expect(keyword).to receive(:initiate_scraping)
        keyword.save
      end

      it 'schedules WebScrapingJob with a random delay' do
        keyword = build(:keyword)

        expect(WebScrapingJob).to receive(:set).with(wait: anything).and_return(WebScrapingJob)
        expect(WebScrapingJob).to receive(:perform_later).with(keyword)

        keyword.save
      end
    end
  end
end
