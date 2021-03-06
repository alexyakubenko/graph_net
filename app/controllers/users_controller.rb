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

  def index
    @user = current_user
    render 'show'
  end

  def show
    @user = User.find(params[:id])
  end

  def request_friendship
    user = User.find(params[:id])

    current_user.request_friendship!(user)

    flash[:success] = 'Запрос на добавление в друзья отправлен.'

    redirect_to :back
  end

  def apply_friendship
    user = User.find(params[:id])

    if current_user.apply_friendship!(user)
      flash[:success] = "Поздравляем! Вы и #{ user.any_name } теперь друзья!"
    else
      flash[:danger] = "Пользователь #{ user.any_name } не предлагал вам дружить!"
    end

    redirect_to :back
  end

  def reject_friendship
    user = User.find(params[:id])

    current_user.reject_friendship!(user)

    flash[:success] = "Вы и #{ user.any_name } больше не друзья."

    redirect_to :back
  end

  def send_message
    if params[:message].blank?
      flash[:danger] = 'Сообщение не может быть пустым. Введите что-либо.'
      redirect_to :back
      return
    end

    user = User.find(params[:id])

    current_user.send_message!(params[:message], user)

    flash[:success] = "Сообщение пользователю #{ user.any_name } отправлено."
    redirect_to :back
  end

  def friends
    @user = User.find(params[:id]) || current_user
  end

  def messages
    @user = User.find(params[:id])

    @messages = @user ? current_user.rels(between: @user, type: :sent_message_to) : current_user.rels(type: :sent_message_to)

    current_user.read_messages_by!(@user) if @user

    @messages.sort_by!(&:created_at)
  end

  def update_profile_attributes
    current_user.profile_attributes = params[:profile_attributes]
    flash[:info] = 'Профиль обновлен.'
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
