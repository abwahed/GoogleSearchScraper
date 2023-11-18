# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'top@example.com')
      user = build(:user, email: 'top@example.com')
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil)
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many keywords' do
      user = create(:user)
      keyword1 = create(:keyword, user:)
      keyword2 = create(:keyword, user:)
      expect(user.keywords).to include(keyword1, keyword2)
    end

    it 'has many search results through keywords' do
      user = create(:user)
      keyword1 = create(:keyword, user:)
      keyword2 = create(:keyword, user:)
      search1 = create(:search_result, keyword: keyword1)
      search2 = create(:search_result, keyword: keyword2)
      expect(user.search_results).to include(search1, search2)
    end
  end
end
