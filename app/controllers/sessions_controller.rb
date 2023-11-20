# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new; end

  def create
    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      sign_in(user)

      redirect_to root_path
      return
    end

    render turbo_stream: turbo_stream.replace(
      'login_form',
      partial: 'sessions/form', locals: { error: 'Email and Password does not match' }
    )
  end

  private

  def login_params
    params.require(:login).permit(
      :email, :password
    )
  end
end
