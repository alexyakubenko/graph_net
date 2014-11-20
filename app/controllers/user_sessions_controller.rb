class UserSessionsController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:root, success: 'Login successful.')
    else
      redirect_to new_user_path, warning: 'Login failed.'
    end
  end

  def destroy
    logout
    redirect_to(:root, success: 'Logged out!')
  end
end
