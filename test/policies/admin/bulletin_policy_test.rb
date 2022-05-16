# frozen_string_literal: true

require 'test_helper'

module Admin
  class BulletinPolicyTest < PolicyAssertions::Test
    setup do
      @admin = users(:admin)
      @user = users(:regular)
    end

    test 'admin user can get a list of bulletins, view and destroy a bulletin' do
      assert_permit(@admin, [:admin, Bulletin], %i[index? show? destroy?])
    end

    test 'authorized user cannot get a list of bulletins, view and destroy a bulletin' do
      refute_permit(@user, [:admin, Bulletin], %i[index? show? destroy?])
    end

    test 'anonymous user cannot get a list of bulletins, view and destroy a bulletin' do
      refute_permit(nil, [:admin, Bulletin], %i[index? show? destroy?])
    end

    test 'admin user can publish or reject only under moderation bulletins' do
      assert_permit(@admin, [:admin, bulletins(:music_under_moderation)], %i[publish? reject?])
      refute_permit(@admin, [:admin, bulletins(:music_draft)], %i[publish? reject?])
      refute_permit(@admin, [:admin, bulletins(:music_rejected)], %i[publish? reject?])
      refute_permit(@admin, [:admin, bulletins(:music_published)], %i[publish? reject?])
      refute_permit(@admin, [:admin, bulletins(:music_archived)], %i[publish? reject?])
    end

    test 'authorized user cannot publish or reject any bulletins' do
      refute_permit(@user, [:admin, bulletins(:music_under_moderation)], %i[publish? reject?])
      refute_permit(@user, [:admin, bulletins(:music_draft)], %i[publish? reject?])
      refute_permit(@user, [:admin, bulletins(:music_rejected)], %i[publish? reject?])
      refute_permit(@user, [:admin, bulletins(:music_published)], %i[publish? reject?])
      refute_permit(@user, [:admin, bulletins(:music_archived)], %i[publish? reject?])
    end

    test 'anonymous user cannot publish or reject any bulletins' do
      refute_permit(nil, [:admin, bulletins(:music_under_moderation)], %i[publish? reject?])
      refute_permit(nil, [:admin, bulletins(:music_draft)], %i[publish? reject?])
      refute_permit(nil, [:admin, bulletins(:music_rejected)], %i[publish? reject?])
      refute_permit(nil, [:admin, bulletins(:music_published)], %i[publish? reject?])
      refute_permit(nil, [:admin, bulletins(:music_archived)], %i[publish? reject?])
    end

    test 'admin user can send all bulletins to archive except archived bulletins' do
      assert_permit(@admin, [:admin, bulletins(:music_draft)], :archive?)
      assert_permit(@admin, [:admin, bulletins(:music_under_moderation)], :archive?)
      assert_permit(@admin, [:admin, bulletins(:music_rejected)], :archive?)
      assert_permit(@admin, [:admin, bulletins(:music_published)], :archive?)
      refute_permit(@admin, [:admin, bulletins(:music_archived)], :archive?)
    end

    test 'authorized user cannot send all bulletins to archive' do
      refute_permit(@user, [:admin, bulletins(:music_draft)], :archive?)
      refute_permit(@user, [:admin, bulletins(:music_under_moderation)], :archive?)
      refute_permit(@user, [:admin, bulletins(:music_rejected)], :archive?)
      refute_permit(@user, [:admin, bulletins(:music_published)], :archive?)
      refute_permit(@user, [:admin, bulletins(:music_archived)], :archive?)
    end

    test 'anonymous user cannot send all bulletins to archive' do
      refute_permit(nil, [:admin, bulletins(:music_draft)], :archive?)
      refute_permit(nil, [:admin, bulletins(:music_under_moderation)], :archive?)
      refute_permit(nil, [:admin, bulletins(:music_rejected)], :archive?)
      refute_permit(nil, [:admin, bulletins(:music_published)], :archive?)
      refute_permit(nil, [:admin, bulletins(:music_archived)], :archive?)
    end
  end
end
