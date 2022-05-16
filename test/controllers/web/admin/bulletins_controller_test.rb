# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        sign_in(@admin)
      end

      test 'should get a list of bulletins' do
        get(admin_bulletins_url)
        assert_response(:success)
        assert_select('h2', I18n.t('web.admin.bulletins.index.main_title'))
      end

      test 'should show an under moderation bulletin' do
        get(admin_bulletin_url(bulletins(:music_under_moderation)))
        assert_response(:success)
        assert_select('h2', bulletins(:music_under_moderation).title)
      end

      test 'should destroy an existing bulletin' do
        assert_difference(-> { Bulletin.count }, -1) do
          delete(admin_bulletin_url(bulletins(:music_archived)))

          assert_response(:redirect)
          assert_redirected_to(admin_bulletins_url)
          assert { flash[:notice] == I18n.t('web.admin.bulletins.destroy.success') }
        end
      end

      test 'should publish a bulletin' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'published') do
          patch(publish_admin_bulletin_url(bulletins(:music_under_moderation)))

          assert_response(:redirect)
          assert_redirected_to(admin_bulletins_url)
          assert { flash[:notice] == I18n.t('web.admin.bulletins.publish.success') }
        end
      end

      test 'should reject a bulletin' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'rejected') do
          patch(reject_admin_bulletin_url(bulletins(:music_under_moderation)))

          assert_response(:redirect)
          assert_redirected_to(admin_bulletins_url)
          assert { flash[:notice] == I18n.t('web.admin.bulletins.reject.success') }
        end
      end

      test 'should send a bulletin which is being under moderation to archive' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'archived') do
          patch(archive_admin_bulletin_url(bulletins(:music_under_moderation)))

          assert_response(:redirect)
          assert_redirected_to(admin_bulletins_url)
          assert { flash[:notice] == I18n.t('web.admin.bulletins.archive.success') }
        end
      end

      test 'should not send a rejected bulletin to archive for anonymous user' do
        assert_no_changes(-> { bulletins(:music_rejected).reload.state }) do
          sign_out
          patch(archive_admin_bulletin_url(bulletins(:music_rejected)))

          assert_response(:redirect)
          assert_redirected_to(root_url)
          assert { flash[:alert] == I18n.t('pundit.admin/bulletin_policy.archive?') }
        end
      end
    end
  end
end
