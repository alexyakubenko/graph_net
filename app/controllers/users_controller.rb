class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to :root, success: 'User was successfully created. Please log in.'
    else
      render action: :new
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end