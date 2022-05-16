# frozen_string_literal: true

require 'test_helper'

module Admin
  class CategoryPolicyTest < PolicyAssertions::Test
    setup do
      @admin = users(:admin)
      @user = users(:regular)
    end

    test 'admin user can commit all actions' do
      assert_permit(@admin, [:admin, Category], %i[index? new? create? edit? update? destroy?])
    end

    test 'authorized user cannot commit all actions' do
      refute_permit(@user, [:admin, Category], %i[index? new? create? edit? update? destroy?])
    end

    test 'anonymous user cannot commit all actions' do
      refute_permit(nil, [:admin, Category], %i[index? new? create? edit? update? destroy?])
    end
  end
end
