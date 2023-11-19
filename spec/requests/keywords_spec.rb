# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Keywords', type: :request do
  let(:user) { create(:user) }

  before do
    session = { user_id: user.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get new_keyword_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Upload Keywords</title>')
    end
  end

  describe 'POST #create' do
    context 'with valid CSV file' do
      it 'creates keywords and redirects to index' do
        expect do
          post keywords_path,
               params: { keywords: { file: fixture_file_upload('valid_keywords.csv', 'text/csv') } }
        end.to change(Keyword, :count).by(3)
        expect(response).to redirect_to(keywords_path)
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid CSV file' do
      it 'does not create keywords and redirects to new' do
        expect do
          post keywords_path,
               params: { keywords: { file: fixture_file_upload('invalid_keywords.txt', 'text/plain') } }
        end.not_to change(Keyword, :count)
        expect(response).to redirect_to(new_keyword_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'without a file' do
      it 'redirects to new with an alert' do
        expect do
          post keywords_path,
               params: { keywords: { file: nil } }
        end.not_to change(Keyword, :count)
        expect(response).to redirect_to(new_keyword_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #index' do
    it 'renders the index template with keywords' do
      keywords = create_list(:keyword, 5, user:)
      get keywords_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Uploaded Keywords</title>')
    end
  end

  describe 'GET #search_result' do
    let(:keyword) { create(:keyword, user:) }

    it 'renders the search_result template' do
      search_result = create(:search_result, keyword:)
      get search_result_keyword_path(keyword)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>Search Result for #{keyword.name}</title>")
      expect(response.body).to include("<p>AdWords Advertisers: #{search_result.adwords_count}</p>")
      expect(response.body).to include("<p>Total Links: #{search_result.links_count}</p>")
      expect(response.body).to include("<p>Total Search Results: #{search_result.total_results}</p>")
    end
  end
end
