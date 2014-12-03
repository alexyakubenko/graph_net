class UserSessionsController < ApplicationController
  skip_before_filter :require_login, only: :create

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(:root, success: 'Добро пожаловать.')
    else
      flash[:warning] = 'Имя пользователя, либо пароль не верны. Попробуйте снова.'
      redirect_to new_user_path
    end
  end

  def destroy
    logout
    redirect_to(:root, success: 'Всего доброго!')
  end
end
