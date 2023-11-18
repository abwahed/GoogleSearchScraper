require 'rails_helper'

RSpec.describe SearchResult, type: :model do
  describe 'associations' do
    it 'belongs to a keyword' do
      keyword = create(:keyword)
      search_result = create(:search_result, keyword:)
      expect(search_result.keyword).to eq(keyword)
    end

    it 'has one user through keywords' do
      user = create(:user)
      keyword = create(:keyword, user:)
      search = create(:search_result, keyword:)
      expect(search.user).to eq(user)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      search_result = build(:search_result)
      expect(search_result).to be_valid
    end

    it 'is not valid without adwords_count' do
      search_result = build(:search_result, adwords_count: nil)
      expect(search_result).to_not be_valid
    end

    it 'is not valid with negative adwords_count' do
      search_result = build(:search_result, adwords_count: -5)
      expect(search_result).to_not be_valid
    end

    it 'is not valid without links_count' do
      search_result = build(:search_result, links_count: nil)
      expect(search_result).to_not be_valid
    end

    it 'is not valid with negative links_count' do
      search_result = build(:search_result, links_count: -5)
      expect(search_result).to_not be_valid
    end

    it 'is not valid without total_results' do
      search_result = build(:search_result, total_results: nil)
      expect(search_result).to_not be_valid
    end

    it 'is not valid without html_code' do
      search_result = build(:search_result, html_code: nil)
      expect(search_result).to_not be_valid
    end
  end
end
