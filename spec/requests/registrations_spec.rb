# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'GET #new' do
    it 'renders the new template' do
      get '/sign_up'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('<title>Sign Up</title>')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user and signs them in' do
        expect do
          post sign_up_path,
               params: { signup: attributes_for(:user) }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(root_path)
        expect(session[:user_id]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template with errors' do
        expect do
          post sign_up_path,
               params: { signup: { email: 'invalid_email' } }
        end.not_to change(User, :count)
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Sign Up')
        expect(session[:user_id]).to_not be_present
      end
    end
  end
end
