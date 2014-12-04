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

    current_user.create_rel(:friend_request, user, weight: 1.0)

    flash[:success] = 'Запрос на добавление в друзья отправлен. Спасибо.'
    render json: { email: user.email }
  end

  def confirm_friend
    user = User.find(params[:id])

    current_user.rels(dir: :incoming, type: :friend_request, end_node: user).first.destroy
    current_user.create_rel(:friend, user, weight: 5.0)

    flash[:success] = "Поздравляем! Вы и #{ user.any_name } теперь друзья!"

    redirect_to :back
  end

  def reject_friend
    user = User.find(params[:id])

    current_user.rels(between: user).select { |r| r.rel_type.in?([:friend, :friend_request]) }.each(&:destroy)

    flash[:success] = "Вы и #{ user.any_name } больше не друзья."

    redirect_to :back
  end

  def friends

  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
