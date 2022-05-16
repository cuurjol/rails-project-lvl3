# frozen_string_literal: true

require 'test_helper'

class BulletinPolicyTest < PolicyAssertions::Test
  setup do
    @user = users(:regular)
    @other_user = users(:another_regular)
  end

  test 'authorized user can create a new bulletin' do
    assert_permit(@user, Bulletin, %i[new? create?])
  end

  test 'anonymous user cannot create a new bulletin' do
    refute_permit(nil, Bulletin, %i[new? create?])
  end

  test 'authorized user can view all his bulletins' do
    assert_permit(@user, bulletins(:music_draft), :show?)
    assert_permit(@user, bulletins(:music_under_moderation), :show?)
    assert_permit(@user, bulletins(:music_published), :show?)
    assert_permit(@user, bulletins(:music_rejected), :show?)
    assert_permit(@user, bulletins(:music_archived), :show?)
  end

  test 'other authorized user can view only published bulletins' do
    assert_permit(@other_user, bulletins(:music_published), :show?)
    refute_permit(@other_user, bulletins(:music_draft), :show?)
    refute_permit(@other_user, bulletins(:music_under_moderation), :show?)
    refute_permit(@other_user, bulletins(:music_rejected), :show?)
    refute_permit(@other_user, bulletins(:music_draft), :show?)
  end

  test 'anonymous user can view only published bulletins' do
    assert_permit(nil, bulletins(:music_published), :show?)
    refute_permit(nil, bulletins(:music_draft), :show?)
    refute_permit(nil, bulletins(:music_under_moderation), :show?)
    refute_permit(nil, bulletins(:music_rejected), :show?)
    refute_permit(nil, bulletins(:music_draft), :show?)
  end

  test 'authorized user can update or moderate only draft or rejected bulletins' do
    assert_permit(@user, bulletins(:music_draft), %i[edit? update? moderate?])
    assert_permit(@user, bulletins(:music_rejected), %i[edit? update? moderate?])
    refute_permit(@user, bulletins(:music_under_moderation), %i[edit? update? moderate?])
    refute_permit(@user, bulletins(:music_published), %i[edit? update? moderate?])
    refute_permit(@user, bulletins(:music_archived), %i[edit? update? moderate?])
  end

  test "other authorized user cannot update or moderate other people's bulletins" do
    refute_permit(@other_user, bulletins(:music_draft), %i[edit? update? moderate?])
    refute_permit(@other_user, bulletins(:music_rejected), %i[edit? update? moderate?])
    refute_permit(@other_user, bulletins(:music_under_moderation), %i[edit? update? moderate?])
    refute_permit(@other_user, bulletins(:music_published), %i[edit? update? moderate?])
    refute_permit(@other_user, bulletins(:music_archived), %i[edit? update? moderate?])
  end

  test "anonymous user cannot update or moderate other people's bulletins" do
    refute_permit(nil, bulletins(:music_draft), %i[edit? update? moderate?])
    refute_permit(nil, bulletins(:music_rejected), %i[edit? update? moderate?])
    refute_permit(nil, bulletins(:music_under_moderation), %i[edit? update? moderate?])
    refute_permit(nil, bulletins(:music_published), %i[edit? update? moderate?])
    refute_permit(nil, bulletins(:music_archived), %i[edit? update? moderate?])
  end

  test 'authorized user can send all his bulletins to archive except archived bulletins' do
    assert_permit(@user, bulletins(:music_draft), :archive?)
    assert_permit(@user, bulletins(:music_rejected), :archive?)
    assert_permit(@user, bulletins(:music_under_moderation), :archive?)
    assert_permit(@user, bulletins(:music_published), :archive?)
    refute_permit(@user, bulletins(:music_archived), :archive?)
  end

  test "other authorized user cannot send other people's bulletins to archive" do
    refute_permit(@other_user, bulletins(:music_draft), :archive?)
    refute_permit(@other_user, bulletins(:music_rejected), :archive?)
    refute_permit(@other_user, bulletins(:music_under_moderation), :archive?)
    refute_permit(@other_user, bulletins(:music_published), :archive?)
    refute_permit(@other_user, bulletins(:music_archived), :archive?)
  end

  test "anonymous user cannot send other people's bulletins to archive" do
    refute_permit(nil, bulletins(:music_draft), :archive?)
    refute_permit(nil, bulletins(:music_rejected), :archive?)
    refute_permit(nil, bulletins(:music_under_moderation), :archive?)
    refute_permit(nil, bulletins(:music_published), :archive?)
    refute_permit(nil, bulletins(:music_archived), :archive?)
  end

  test 'authorized user can send only published bulletins to draft' do
    assert_permit(@user, bulletins(:music_published), :draft?)
    refute_permit(@user, bulletins(:music_draft), :draft?)
    refute_permit(@user, bulletins(:music_under_moderation), :draft?)
    refute_permit(@user, bulletins(:music_rejected), :draft?)
    refute_permit(@user, bulletins(:music_draft), :draft?)
  end

  test "other authorized user cannot send other people's bulletins to draft" do
    refute_permit(@other_user, bulletins(:music_published), :draft?)
    refute_permit(@other_user, bulletins(:music_draft), :draft?)
    refute_permit(@other_user, bulletins(:music_under_moderation), :draft?)
    refute_permit(@other_user, bulletins(:music_rejected), :draft?)
    refute_permit(@other_user, bulletins(:music_draft), :draft?)
  end

  test "anonymous user cannot send other people's bulletins to draft" do
    refute_permit(nil, bulletins(:music_published), :draft?)
    refute_permit(nil, bulletins(:music_draft), :draft?)
    refute_permit(nil, bulletins(:music_under_moderation), :draft?)
    refute_permit(nil, bulletins(:music_rejected), :draft?)
    refute_permit(nil, bulletins(:music_draft), :draft?)
  end
end
