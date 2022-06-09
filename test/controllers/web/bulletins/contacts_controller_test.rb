# frozen_string_literal: true

require 'test_helper'

module Web
  module Bulletins
    class ContactsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @published_bulletin = bulletins(:music_published)
        @archived_bulletin = bulletins(:music_archived)
      end

      test 'user sends email from bulletin contact form' do
        params = { contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                              bulletin_id: @published_bulletin.id } }

        assert_emails(1) do
          post(bulletin_contacts_url(@published_bulletin), params: params)
          assert_response(:redirect)
          assert_redirected_to(bulletin_url(@published_bulletin))
          assert { flash[:notice] == I18n.t('web.bulletins.contacts.create.success') }

          assert { ActionMailer::Base.deliveries.last.from.last == params[:contact][:email] }
          assert { ActionMailer::Base.deliveries.last.to.last == @published_bulletin.user.email }
          assert { ActionMailer::Base.deliveries.last.subject == I18n.t('mail_form.bulletins.contact.subject') }
          assert { ActionMailer::Base.deliveries.last.text_part.body.to_s.match?(params[:contact][:message]) }
        end
      end

      test 'user cannot send email from bulletin contact form to himself' do
        params = { contact: { name: 'Test user', email: @published_bulletin.user.email, message: 'Test message',
                              bulletin_id: @published_bulletin.id } }

        assert_emails(0) do
          post(bulletin_contacts_url(@published_bulletin), params: params)
          assert_response(:redirect)
          assert_redirected_to(bulletin_url(@published_bulletin))
          assert { flash[:alert] == I18n.t('web.bulletins.contacts.create.failure') }
        end
      end

      test 'failed pundit authorization of bulletin contact form for not published bulletins' do
        params = { contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                              bulletin_id: @archived_bulletin.id } }

        assert_emails(0) do
          assert_no_pundit_authorization(:'bulletins/contact_policy', :create?) do
            post(bulletin_contacts_url(@archived_bulletin), params: params)
          end
        end
      end
    end
  end
end
