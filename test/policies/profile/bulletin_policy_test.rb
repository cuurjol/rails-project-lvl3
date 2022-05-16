# frozen_string_literal: true

require 'test_helper'

module Profile
  class BulletinPolicyTest < PolicyAssertions::Test
    test 'authorized user can view his profile page' do
      assert_permit(users(:regular), [:profile, Bulletin], :show?)
    end

    test 'anonymous user cannot view any profile page' do
      refute_permit(nil, [:profile, Bulletin], :show?)
    end
  end
end
