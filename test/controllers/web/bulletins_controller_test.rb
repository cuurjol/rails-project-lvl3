# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:regular)
      sign_in(@user)
    end

    test 'should get a list of bulletins' do
      get(bulletins_url)
      assert_response(:success)
      assert_select('h2', I18n.t('web.bulletins.index.main_title'))
    end

    test 'should get a creating form of bulletin' do
      get(new_bulletin_url)
      assert_response(:success)
      assert_select('h2', I18n.t('web.bulletins.new.main_title'))
    end

    test 'should create a new bulletin' do
      params = { bulletin: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph,
                             category_id: Category.find_by(name: 'Music').id,
                             image: fixture_file_upload('music.jpg', 'image/jpg') } }

      assert_difference(-> { Bulletin.count }) do
        post(bulletins_url, params: params)

        assert_response(:redirect)
        assert_redirected_to(bulletin_url(Bulletin.last))
        assert { flash[:notice] == I18n.t('web.bulletins.create.success') }
      end
    end

    test 'should not create a new bulletin' do
      params = { bulletin: { title: '', description: '', category_id: '', image: nil } }

      assert_no_difference(-> { Bulletin.count }) do
        post(bulletins_url, params: params)

        assert_response(:success)
        assert { flash[:alert] == I18n.t('web.bulletins.create.failure') }
      end
    end

    test 'should show a published bulletin' do
      get(bulletin_url(bulletins(:music_published)))
      assert_response(:success)
      assert_select('h2', bulletins(:music_published).title)
    end

    test 'should get an editing form of bulletin' do
      get(edit_bulletin_url(bulletins(:music_draft)))
      assert_response(:success)
      assert_select('h2', I18n.t('web.bulletins.edit.main_title'))
    end

    test 'should update an existing bulletin' do
      bulletin = bulletins(:music_draft)
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph

      assert_changes(-> { bulletin.reload.title }, to: title) do
        assert_changes(-> { bulletin.reload.description }, to: description) do
          put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })

          assert_response(:redirect)
          assert_redirected_to(bulletin_url(bulletin))
          assert { flash[:notice] == I18n.t('web.bulletins.update.success') }
        end
      end
    end

    test 'should not update an existing bulletin' do
      bulletin = bulletins(:music_draft)

      assert_no_changes(-> { bulletin.reload.title }) do
        assert_no_changes(-> { bulletin.reload.description }) do
          put(bulletin_url(bulletin), params: { bulletin: { title: '', description: '' } })

          assert_response(:success)
          assert { flash[:alert] == I18n.t('web.bulletins.update.failure') }
        end
      end
    end

    test 'should send a draft bulletin to moderate' do
      assert_changes(-> { bulletins(:music_draft).reload.state }, to: 'under_moderation') do
        patch(moderate_bulletin_url(bulletins(:music_draft)))

        assert_response(:redirect)
        assert_redirected_to(profile_url)
        assert { flash[:notice] == I18n.t('web.bulletins.moderate.success') }
      end
    end

    test 'should send a rejected bulletin to archive' do
      assert_changes(-> { bulletins(:music_rejected).reload.state }, to: 'archived') do
        patch(archive_bulletin_url(bulletins(:music_rejected)))

        assert_response(:redirect)
        assert_redirected_to(profile_url)
        assert { flash[:notice] == I18n.t('web.bulletins.archive.success') }
      end
    end

    test 'should send a published bulletin to draft' do
      assert_changes(-> { bulletins(:music_published).reload.state }, to: 'draft') do
        patch(draft_bulletin_url(bulletins(:music_published)))

        assert_response(:redirect)
        assert_redirected_to(profile_url)
        assert { flash[:notice] == I18n.t('web.bulletins.draft.success') }
      end
    end

    test 'should not send a published bulletin to draft for anonymous user' do
      assert_no_changes(-> { bulletins(:music_archived).reload.state }) do
        sign_out
        patch(draft_bulletin_url(bulletins(:music_published)))

        assert_response(:redirect)
        assert_redirected_to(root_url)
        assert { flash[:alert] == I18n.t('pundit.bulletin_policy.draft?') }
      end
    end
  end
end
