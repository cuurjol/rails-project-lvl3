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
      end

      test 'failed admin authorization to view a list of bulletins' do
        assert_no_authorization do
          sign_out
          get(admin_bulletins_url)
        end
      end

      test 'should destroy an existing bulletin' do
        assert_difference(-> { Bulletin.count }, -1) do
          delete(admin_bulletin_url(bulletins(:music_archived)))
          assert_redirected_to(admin_bulletins_url)
          assert { !Bulletin.exists?(title: bulletins(:music_archived).title) }
        end
      end

      test 'failed admin authorization to destroy an existing bulletin' do
        assert_no_difference(-> { Bulletin.count }) do
          assert_no_authorization do
            sign_out
            delete(admin_bulletin_url(bulletins(:music_archived)))
          end
        end
      end

      test 'should publish a bulletin' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'published') do
          patch(publish_admin_bulletin_url(bulletins(:music_under_moderation)))
          assert_redirected_to(admin_bulletins_url)
        end
      end

      test 'should not publish an archived bulletin' do
        assert_no_changes(-> { bulletins(:music_archived).reload.state }) do
          patch(publish_admin_bulletin_url(bulletins(:music_archived)))
          assert_redirected_to(admin_bulletins_url)
        end
      end

      test 'failed admin authorization to publish a bulletin' do
        assert_no_changes(-> { bulletins(:music_under_moderation).reload.state }) do
          assert_no_authorization do
            sign_out
            patch(publish_admin_bulletin_url(bulletins(:music_under_moderation)))
          end
        end
      end

      test 'should reject a bulletin' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'rejected') do
          patch(reject_admin_bulletin_url(bulletins(:music_under_moderation)))
          assert_redirected_to(admin_bulletins_url)
        end
      end

      test 'should not reject an archived bulletin' do
        assert_no_changes(-> { bulletins(:music_archived).reload.state }) do
          patch(reject_admin_bulletin_url(bulletins(:music_archived)))
          assert_redirected_to(admin_bulletins_url)
        end
      end

      test 'failed admin authorization to reject a bulletin' do
        assert_no_changes(-> { bulletins(:music_under_moderation).reload.state }) do
          assert_no_authorization do
            sign_out
            patch(reject_admin_bulletin_url(bulletins(:music_under_moderation)))
          end
        end
      end

      test 'should archive an under moderation bulletin' do
        assert_changes(-> { bulletins(:music_under_moderation).reload.state }, to: 'archived') do
          patch(archive_admin_bulletin_url(bulletins(:music_under_moderation)))
          assert_redirected_to(admin_bulletins_url)
        end
      end

      test 'failed admin authorization to archive an under moderation bulletin' do
        assert_no_changes(-> { bulletins(:music_under_moderation).reload.state }) do
          assert_no_authorization do
            sign_out
            patch(archive_admin_bulletin_url(bulletins(:music_under_moderation)))
          end
        end
      end
    end
  end
end
