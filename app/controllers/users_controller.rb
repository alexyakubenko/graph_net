class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(params[:user][:email], params[:user][:password])
      flash[:success] = 'Спасибо за регистрацию.'
      redirect_to :root
    else
      render action: :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def add_friend
    user = User.find(params[:id])

    current_user.create_rel('friend_request', user, weight: 1.0)

    flash[:success] = 'Запрос на добавление в друзья отправлен. Спасибо.'
    render json: { email: user.email }
  end

  def friends

  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
