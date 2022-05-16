# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfilesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:regular)
      sign_in(@user)
    end

    test 'should show a profile page' do
      get(profile_url)
      assert_response(:success)
      assert_select('h2', I18n.t('web.profiles.show.main_title'))
      assert { Bulletin.where(user: @user).count == @user.bulletins.count }
    end

    test 'should not show a profile page for anonymous user' do
      sign_out
      get(profile_url)
      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { flash[:alert] == I18n.t('pundit.profile/bulletin_policy.show?') }
    end
  end
end
