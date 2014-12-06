class UsersController < ApplicationController
  include AttributesHelper

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

  def add_friend
    user = User.find(params[:id])

    current_user.create_rel(:friend_request, user, weight: 1.0)

    flash[:success] = 'Запрос на добавление в друзья отправлен. Спасибо.'

    redirect_to :back
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

  def send_message
    if params[:message].blank?
      flash[:danger] = 'Сообщение не может быть пустым. Введите что-либо.'
      redirect_to :back
      return
    end

    user = User.find(params[:id])
    current_user.create_rel(:message, user, weight: 0.25, body: params[:message], unread: true, created_at: Time.now.strftime('%c'))
    flash[:success] = "Сообщение пользователю #{ user.any_name } отправлено."
    redirect_to :back
  end

  def friends
  end

  def messages
    @user = User.find(params[:id])

    @messages = @user ? current_user.rels(between: @user, type: :message) : current_user.rels(type: :message)

    mark_unread_messages! if @user

    @messages.sort_by!{ |m| m.props[:created_at] }
  end

  def delete_attribute
    relation = Neo4j::Relationship.load(params[:id])
    if relation && relation.start_node == current_user
      relation.del
      render json: { success: true, undefined_attribute_types_html: undefined_attribute_types_html }
    else
      render json: { success: false }
    end
  end

  def create_attribute
    attribute = Attribute.find_by(value: params[:value]) || Attribute.create(value: params[:value])
    relation = current_user.create_rel(params[:type], attribute, weight: Attribute::RELATIONS[params[:type]][:weight])

    if relation
      render json: {
          success: true,
          html: render_to_string(partial: 'users/attribute', locals: { attribute: relation }, formats: [:html]),
          undefined_attribute_types_html: undefined_attribute_types_html
      }
    else
      render json: { success: false }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def mark_unread_messages!
    Neo4j::Session.query(
        "MATCH (u)-[r:message]->(i) WHERE i.uuid = {i_id} AND u.uuid = {u_id} AND r.unread = true SET r.unread = false",
        i_id: current_user.uuid,
        u_id: @user.uuid
    )
  end
end
