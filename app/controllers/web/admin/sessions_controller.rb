# frozen_string_literal: true

module Web
  module Admin
    class SessionsController < Web::ApplicationController
      def new; end

      def create
        user = User.authenticate(**admin_session_params.to_h.symbolize_keys)

        if user.present? && user.admin?
          sign_in(user)
          redirect_to(root_path, notice: t('.success'))
        else
          flash.now.alert = t('.failure')
          render(:new)
        end
      end

      def destroy
        sign_out
        redirect_to(root_path, notice: t('.success'))
      end

      private

      def admin_session_params
        params.require(:admin_session).permit(:email, :password)
      end
    end
  end
end
