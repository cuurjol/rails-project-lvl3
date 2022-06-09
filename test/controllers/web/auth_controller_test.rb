# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'should check Github auth' do
      post(auth_request_path('github'))
      assert_redirected_to(callback_auth_url('github'))
    end

    test 'should check Google auth' do
      post(auth_request_path('google_oauth2'))
      assert_redirected_to(callback_auth_url('google_oauth2'))
    end

    test 'should create and authenticate a new user via Github' do
      email = Faker::Internet.email
      name = Faker::Name.first_name
      auth_hash = { info: { email: email, name: name }, provider: 'github', uid: '12345' }
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      assert_difference(-> { User.count }) do
        get(callback_auth_url(auth_hash[:provider]))
        assert_redirected_to(root_url)
        assert(user_signed_in?)
      end
    end

    test 'should not create and authenticate a new user via Github due to validation errors' do
      auth_hash = { info: { email: '', name: '' }, provider: 'github', uid: '12345' }
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      assert_no_difference(-> { User.count }) do
        get(callback_auth_url(auth_hash[:provider]))
        assert_redirected_to(root_url)
        assert_not(user_signed_in?)
      end
    end

    test 'should destroy a session for authorized user' do
      sign_in(users(:regular))
      delete(sign_out_url)
      assert_redirected_to(root_url)
    end

    test 'should destroy a session for admin user' do
      sign_in(users(:admin))
      delete(sign_out_url)
      assert_redirected_to(root_url)
    end

    test 'should not destroy an invalid session' do
      delete(sign_out_url)
      assert_redirected_to(root_url)
    end
  end
end
