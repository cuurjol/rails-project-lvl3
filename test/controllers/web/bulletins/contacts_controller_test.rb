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
        params = { bulletins_contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                                        bulletin_id: @published_bulletin.id } }

        assert_emails(1) do
          post(bulletin_contacts_url(@published_bulletin), params: params)
          assert_redirected_to(bulletin_url(@published_bulletin))

          mail = ActionMailer::Base.deliveries.last
          assert { mail.from.last == params[:bulletins_contact][:email] }
          assert { mail.to.last == @published_bulletin.user.email }
          assert { mail.subject == I18n.t('mail_form.bulletins.contact.subject') }
          assert { mail.text_part.body.to_s.match?(params[:bulletins_contact][:message]) }
        end
      end

      test 'user cannot send email from bulletin contact form to himself' do
        params = { bulletins_contact: { name: 'Test user', email: @published_bulletin.user.email,
                                        message: 'Test message', bulletin_id: @published_bulletin.id } }

        assert_emails(0) do
          post(bulletin_contacts_url(@published_bulletin), params: params)
          assert_redirected_to(bulletin_url(@published_bulletin))
        end
      end

      test 'failed pundit authorization of bulletin contact form for not published bulletins' do
        params = { bulletins_contact: { name: 'Test user', email: 'test_user@example.com', message: 'Test message',
                                        bulletin_id: @archived_bulletin.id } }

        assert_emails(0) do
          assert_no_authorization do
            post(bulletin_contacts_url(@archived_bulletin), params: params)
          end
        end
      end
    end
  end
end
