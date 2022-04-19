# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'should check Github auth' do
      post(auth_request_path('github'))
      assert_response(:redirect)
      assert_redirected_to(callback_auth_url('github'))
    end

    test 'should check Google auth' do
      post(auth_request_path('google_oauth2'))
      assert_response(:redirect)
      assert_redirected_to(callback_auth_url('google_oauth2'))
    end

    test 'should create and authenticate a new user via Github' do
      auth_hash = { info: { email: Faker::Internet.email, name: Faker::Name.first_name },
                    provider: 'github', uid: '12345' }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
      get(callback_auth_url(auth_hash[:provider]))

      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { flash[:notice] == I18n.t('web.auth.callback.success', provider: auth_hash[:provider]) }

      assert(User.exists?(email: auth_hash[:info][:email].downcase))
      assert(signed_in?)
    end

    test 'should not create and authenticate a new user via Github' do
      auth_hash = { info: { email: '', name: '' }, provider: 'github', uid: '12345' }
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
      get(callback_auth_url(auth_hash[:provider]))

      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { flash[:alert] == I18n.t('web.auth.callback.failure', provider: auth_hash[:provider]) }

      assert_not(User.exists?(email: auth_hash[:info][:email].downcase))
      assert_not(signed_in?)
    end

    test 'should destroy session for authorized user' do
      sign_in(users(:one))
      delete(sign_out_url)

      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { flash[:notice] == I18n.t('web.auth.destroy.success') }
    end
  end
end
