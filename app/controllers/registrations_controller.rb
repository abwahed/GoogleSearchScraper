class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    user = User.new(signup_params)

    if user.save
      sign_in(user)

      redirect_to root_path
      return
    end

    render turbo_stream: turbo_stream.replace('new_user', partial: 'registrations/form', locals: { user: })
  end

  private

  def signup_params
    params.require(:signup).permit(
      :email, :password, :password_confirmation
    )
  end
end
