# frozen_string_literal: true

module Authorization
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def user_signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  delegate(:admin?, to: :current_user, prefix: :user, allow_nil: true)
end
