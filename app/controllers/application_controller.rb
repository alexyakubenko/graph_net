class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :require_login

  after_filter :prepare_unobtrusive_flash

  private

  def not_authenticated
    redirect_to new_user_path, warning: 'Для просмотра данной страницы вам необходимо войти в систему.'
  end
end
