# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        @user = users(:regular)
      end

      test 'should get authorization form' do
        get(new_admin_session_url)
        assert_response(:success)
      end

      test 'should authenticate an admin user' do
        params = { admin_session: { email: @admin.email, password: default_password } }
        post(admin_session_url, params: params)

        assert_response(:redirect)
        assert_redirected_to(root_url)
        assert { flash[:notice] == I18n.t('web.admin.sessions.create.success') }
        assert(user_signed_in?)
      end

      test 'should not authenticate any user' do
        params = { admin_session: { email: @user.email, password: default_password } }
        post(admin_session_url, params: params)

        assert_response(:success)
        assert { flash[:alert] == I18n.t('web.admin.sessions.create.failure') }
        assert_not(user_signed_in?)
      end

      test 'should destroy a session for an admin user' do
        sign_in(@admin)
        delete(admin_session_url)

        assert_response(:redirect)
        assert_redirected_to(root_url)
        assert { flash[:notice] == I18n.t('web.admin.sessions.destroy.success') }
      end
    end
  end
end
