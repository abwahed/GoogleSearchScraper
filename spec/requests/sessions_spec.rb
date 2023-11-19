# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get log_in_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Login</title>')
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid parameters' do
      it 'signs in the user' do
        post login_path,
             params: { login: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template with errors' do
        post login_path,
             params: { login: { email: user.email, password: 'different_password' } }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Email and Password does not match')
        expect(session[:user_id]).to_not be_present
      end
    end
  end
end
