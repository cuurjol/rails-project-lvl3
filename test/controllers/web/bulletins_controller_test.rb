# frozen_string_literal: true

require 'test_helper'

module Web
  # rubocop:disable Metrics/ClassLength
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:regular)
      sign_in(@user)
    end

    test 'should get a list of bulletins' do
      get(bulletins_url)
      assert_response(:success)
    end

    test 'should get a creating form of bulletin' do
      get(new_bulletin_url)
      assert_response(:success)
    end

    test 'failed pundit authorization to view a creating form of bulletin' do
      assert_no_authorization do
        sign_out
        get(new_bulletin_url)
      end
    end

    test 'should create a new bulletin' do
      params = { bulletin: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph,
                             category_id: categories(:music).id,
                             image: fixture_file_upload('music.jpg', 'image/jpg') } }

      assert_difference(-> { Bulletin.count }) do
        post(bulletins_url, params: params)
        assert_redirected_to(bulletin_url(Bulletin.find_by(params[:bulletin].except(:image))))
        assert { Bulletin.exists?(title: params[:bulletin][:title], description: params[:bulletin][:description]) }
      end
    end

    test 'should not create a new bulletin due to validation errors' do
      params = { bulletin: { title: '', description: '', category_id: '', image: nil } }

      assert_no_difference(-> { Bulletin.count }) do
        post(bulletins_url, params: params)
        assert_response(:unprocessable_entity)
      end
    end

    test 'failed pundit authorization to create a new bulletin' do
      params = { bulletin: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph,
                             category_id: categories(:music).id,
                             image: fixture_file_upload('music.jpg', 'image/jpg') } }

      assert_no_difference(-> { Bulletin.count }) do
        assert_no_authorization do
          sign_out
          post(bulletins_url, params: params)
        end
      end
    end

    test 'should show a published bulletin' do
      get(bulletin_url(bulletins(:music_published)))
      assert_response(:success)
    end

    test 'failed pundit authorization to view a draft bulletin' do
      assert_no_authorization do
        sign_out
        get(bulletin_url(bulletins(:music_draft)))
      end
    end

    test 'should get an editing form of bulletin' do
      get(edit_bulletin_url(bulletins(:music_draft)))
      assert_response(:success)
    end

    test 'failed pundit authorization to view an editing form of bulletin' do
      assert_no_authorization do
        sign_out
        get(edit_bulletin_url(bulletins(:music_draft)))
      end
    end

    test 'should update an existing bulletin' do
      bulletin = bulletins(:music_draft)
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph

      assert_changes(-> { bulletin.reload.title }, to: title) do
        assert_changes(-> { bulletin.reload.description }, to: description) do
          put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })
          assert_redirected_to(bulletin_url(bulletin))
        end
      end
    end

    test 'should not update an existing bulletin due to validation errors' do
      bulletin = bulletins(:music_draft)

      assert_no_changes(-> { bulletin.reload.title }) do
        assert_no_changes(-> { bulletin.reload.description }) do
          put(bulletin_url(bulletin), params: { bulletin: { title: '', description: '' } })
          assert_response(:unprocessable_entity)
        end
      end
    end

    test 'failed pundit authorization to update an existing bulletin' do
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph
      bulletin = bulletins(:music_draft)

      assert_no_changes(-> { bulletin.reload.title }) do
        assert_no_changes(-> { bulletin.reload.description }) do
          assert_no_authorization do
            sign_out
            put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })
          end
        end
      end
    end

    test 'should send a draft bulletin to moderate' do
      assert_changes(-> { bulletins(:music_draft).reload.state }, to: 'under_moderation') do
        patch(moderate_bulletin_url(bulletins(:music_draft)))
        assert_redirected_to(profile_url)
      end
    end

    test 'should not send a published bulletin to moderate' do
      assert_no_changes(-> { bulletins(:music_published).reload.state }) do
        patch(moderate_bulletin_url(bulletins(:music_published)))
        assert_redirected_to(profile_url)
      end
    end

    test 'failed pundit authorization to send a published bulletin for moderation' do
      assert_no_changes(-> { bulletins(:music_published).reload.state }) do
        assert_no_authorization do
          sign_out
          patch(moderate_bulletin_url(bulletins(:music_published)))
        end
      end
    end

    test 'should archive a rejected bulletin' do
      assert_changes(-> { bulletins(:music_rejected).reload.state }, to: 'archived') do
        patch(archive_bulletin_url(bulletins(:music_rejected)))
        assert_redirected_to(profile_url)
      end
    end

    test 'failed pundit authorization to archive a rejected bulletin' do
      assert_no_changes(-> { bulletins(:music_rejected).reload.state }) do
        assert_no_authorization do
          sign_out
          patch(archive_bulletin_url(bulletins(:music_rejected)))
        end
      end
    end

    test 'should send a published bulletin to draft' do
      assert_changes(-> { bulletins(:music_published).reload.state }, to: 'draft') do
        patch(draft_bulletin_url(bulletins(:music_published)))
        assert_redirected_to(profile_url)
      end
    end

    test 'should not send an archived bulletin to draft' do
      assert_no_changes(-> { bulletins(:music_archived).reload.state }) do
        patch(draft_bulletin_url(bulletins(:music_archived)))
        assert_redirected_to(profile_url)
      end
    end

    test 'failed pundit authorization to send an archived bulletin to draft' do
      assert_no_changes(-> { bulletins(:music_archived).reload.state }) do
        assert_no_authorization do
          sign_out
          patch(draft_bulletin_url(bulletins(:music_archived)))
        end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
