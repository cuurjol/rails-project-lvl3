# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      user = User.find_or_create_with_omniauth(auth)

      if user.persisted?
        sign_in(user)
        redirect_to(root_path, notice: t('.success', provider: auth.provider))
      else
        redirect_to(root_path, alert: t('.failure', provider: auth.provider))
      end
    end

    def destroy
      if session[:user_id].present?
        flash_message = if User.find(session[:user_id]).admin?
                          { notice: t('.admin_success') }
                        else
                          { notice: t('.user_success') }
                        end

        sign_out
        redirect_to(root_path, flash_message)
      else
        redirect_to(root_path, notice: t('.failure'))
      end
    end
  end
end
