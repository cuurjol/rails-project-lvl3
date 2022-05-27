# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfilesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:regular)
      sign_in(@user)
    end

    test 'should get a profile page' do
      get(profile_url)
      assert_response(:success)
      assert { !@user.bulletins.exists?(id: Bulletin.where(category: categories(:books)).pluck(:id)) }
    end

    test 'failed pundit authorization to view a profile page' do
      assert_no_pundit_authorization(:'profile/bulletin_policy', :show?) do
        sign_out
        get(profile_url)
      end
    end
  end
end
