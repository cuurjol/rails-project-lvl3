# frozen_string_literal: true

module Web
  module Admin
    class ApplicationController < Web::ApplicationController
      before_action :authorized_for_user_admin

      private

      def authorized_for_user_admin
        return if user_admin?

        redirect_to(root_path, alert: t('web.admin.application.user_admin.failure'))
      end
    end
  end
end
