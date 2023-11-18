class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :null_session

  before_action :authenticate_user!

  def user_signed_in?
    current_user.present?
  end

  def sign_in(user)
    session[:user_id] = user.id
    cookies.encrypted[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
    cookies.delete(:user_id)
  end

  private

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.encrypted[:user_id].present?
      @current_user ||= User.find_by(id: cookies.encrypted[:user_id])
    else
      @current_user = nil
    end
  end

  def authenticate_user!
    redirect_to log_in_path, alert: 'You need to login to view this content' unless current_user.present?
  end
end
