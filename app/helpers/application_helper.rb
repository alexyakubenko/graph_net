module ApplicationHelper
  def js_nothing
    'javascript:void(0);'
  end

  def my_page?
    @user == current_user
  end
end
