# frozen_string_literal: true

require 'test_helper'

class BulletinContactPolicyTest < PolicyAssertions::Test
  setup do
    @user = users(:regular)
    @bulletin = bulletins(:books_published)
    @other_bulletin = bulletins(:books_draft)
  end

  test 'user can send email for published bulletin' do
    params = { name: 'Test', email: @user.email, message: 'Test message', bulletin_id: @bulletin.id }
    bulletin_contact = BulletinContact.new(params)
    assert_permit(@user, bulletin_contact, :create?)
  end

  test 'user cannot send email for not published bulletin' do
    params = { name: 'Test', email: @user.email, message: 'Test message', bulletin_id: @other_bulletin.id }
    bulletin_contact = BulletinContact.new(params)
    refute_permit(@user, bulletin_contact, :create?)
  end
end
