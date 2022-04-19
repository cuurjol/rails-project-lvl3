# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinContactsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @bulletin = bulletins(:music)
    end

    test 'should send email' do
      params = { bulletin_contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                                     bulletin_id: @bulletin.id, owner_email: @bulletin.user.email } }

      post(bulletin_contacts_url(@bulletin), params: params)
      assert_response(:redirect)
      assert_redirected_to(bulletin_url(@bulletin))
      assert { flash[:notice] == I18n.t('web.bulletin_contacts.create.success') }

      assert { ActionMailer::Base.deliveries.count == 1 }
      assert { ActionMailer::Base.deliveries.last.from.last == params[:bulletin_contact][:email] }
      assert { ActionMailer::Base.deliveries.last.to.last == params[:bulletin_contact][:owner_email] }
      assert { ActionMailer::Base.deliveries.last.subject == I18n.t('mail_form.bulletin_contact.subject') }
      assert { ActionMailer::Base.deliveries.last.text_part.body.to_s.match?(params[:bulletin_contact][:message]) }
    end

    test 'should not send email to itself' do
      params = { bulletin_contact: { name: 'Test user', email: @bulletin.user.email, message: 'Test message',
                                     bulletin_id: @bulletin.id, owner_email: @bulletin.user.email } }

      post(bulletin_contacts_url(@bulletin), params: params)
      assert_response(:redirect)
      assert_redirected_to(bulletin_url(@bulletin))
      assert { flash[:alert] == I18n.t('web.bulletin_contacts.create.failure') }

      assert { ActionMailer::Base.deliveries.count.zero? }
    end

    test 'should not send email to not owner bulletin' do
      params = { bulletin_contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                                     bulletin_id: @bulletin.id, owner_email: 'foreign_user@exaqmple.com' } }

      post(bulletin_contacts_url(@bulletin), params: params)
      assert_response(:redirect)
      assert_redirected_to(bulletin_url(@bulletin))

      assert { ActionMailer::Base.deliveries.count.zero? }
    end
  end
end
