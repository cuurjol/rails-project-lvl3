# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        sign_in(@admin)
      end

      test 'should get a list of users' do
        get(admin_users_url)
        assert_response(:success)
      end

      test 'failed admin authorization to view a list of users' do
        assert_no_authorization do
          sign_out
          get(admin_users_url)
        end
      end

      test 'should get an editing form of user' do
        get(edit_admin_user_url(users(:regular)))
        assert_response(:success)
      end

      test 'failed admin authorization to view an editing form of user' do
        assert_no_authorization do
          sign_out
          get(edit_admin_user_url(users(:regular)))
        end
      end

      test 'should update an existing user' do
        user = users(:regular)
        auth = Faker::Omniauth.google
        name = auth[:info][:name]
        email = auth[:info][:email]

        assert_changes(-> { user.reload.name }, to: name) do
          assert_changes(-> { user.reload.email }, to: email) do
            put(admin_user_url(user), params: { user: { name: name, email: email } })
            assert_redirected_to(admin_users_url)
          end
        end
      end

      test 'should not update an existing user due to validation errors' do
        user = users(:regular)

        assert_no_changes(-> { user.reload.name }) do
          assert_no_changes(-> { user.reload.email }) do
            put(admin_user_url(user), params: { user: { name: '', email: '' } })
            assert_response(:unprocessable_entity)
          end
        end
      end

      test 'failed admin authorization to update an existing user' do
        user = users(:regular)
        auth = Faker::Omniauth.google
        name = auth[:info][:name]
        email = auth[:info][:email]

        assert_no_changes(-> { user.reload.name }) do
          assert_no_changes(-> { user.reload.email }) do
            assert_no_authorization do
              sign_out
              put(admin_user_url(user), params: { user: { name: name, email: email } })
            end
          end
        end
      end

      test 'should destroy an existing user' do
        assert_difference(-> { User.count }, -1) do
          delete(admin_user_url(users(:regular)))
          assert_redirected_to(admin_users_url)
          assert { !User.exists?(name: users(:regular).name) }
        end
      end

      test 'should not destroy an admin existing user (himself)' do
        assert_no_difference(-> { User.count }) do
          delete(admin_user_url(users(:admin)))
          assert_redirected_to(admin_users_url)
          assert { User.exists?(name: users(:admin).name) }
        end
      end

      test 'failed admin authorization to destroy an existing user' do
        assert_no_difference(-> { User.count }) do
          assert_no_authorization do
            sign_out
            delete(admin_user_url(users(:regular)))
          end
        end
      end
    end
  end
end
