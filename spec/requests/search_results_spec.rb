require 'rails_helper'

RSpec.describe "SearchResults", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/search_results/show"
      expect(response).to have_http_status(:success)
    end
  end

end
