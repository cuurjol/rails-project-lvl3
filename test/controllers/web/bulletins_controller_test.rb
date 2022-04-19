# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      sign_in(@user)
    end

    test 'should get index view' do
      get(bulletins_url)
      assert_response(:success)
    end

    test 'should get index view for unauthenticated user' do
      sign_out
      get(bulletins_url)
      assert_response(:success)
    end

    test 'should get new view' do
      get(new_bulletin_url)
      assert_response(:success)
    end

    test 'should not get new view for unauthenticated user' do
      sign_out
      get(new_bulletin_url)
      assert_response(:redirect)
      assert_redirected_to(root_url)
    end

    test 'should create bulletin' do
      params = { bulletin: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph,
                             category_id: Category.find_by(name: 'Music').id,
                             image: fixture_file_upload('music.jpg', 'image/jpg') } }

      assert_difference('Bulletin.count') { post(bulletins_url, params: params) }
      assert_response(:redirect)
      assert_redirected_to(bulletin_url(Bulletin.last))
      assert { flash[:notice] == I18n.t('web.bulletins.create.success') }
      assert { Bulletin.exists?(params[:bulletin].except(:image).merge(user: @user)) }
    end

    test 'should not create bulletin for unauthenticated user' do
      sign_out
      params = { bulletin: { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph,
                             category_id: Category.find_by(name: 'Music').id,
                             image: fixture_file_upload('music.jpg', 'image/jpg') } }

      assert_no_difference('Bulletin.count') { post(bulletins_url, params: params) }
      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { !Bulletin.exists?(params[:bulletin].except(:image).merge(user: @user)) }
    end

    test 'should show bulletin view' do
      get(bulletin_url(bulletins(:music)))
      assert_response(:success)
    end

    test 'should show bulletin view for unauthenticated user' do
      sign_out
      get(bulletin_url(bulletins(:music)))
      assert_response(:success)
    end

    test 'should get edit view' do
      get(edit_bulletin_url(bulletins(:music)))
      assert_response(:success)
    end

    test 'should not get edit view for unauthenticated user' do
      sign_out
      get(edit_bulletin_url(bulletins(:music)))
      assert_response(:redirect)
      assert_redirected_to(root_url)
    end

    test 'should update bulletin' do
      bulletin = bulletins(:music)
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph

      put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })
      bulletin.reload

      assert_response(:redirect)
      assert_redirected_to(bulletin_url(bulletin))
      assert { flash[:notice] == I18n.t('web.bulletins.update.success') }
      assert { bulletin.title == title }
      assert { bulletin.description == description }
    end

    test 'should not update a foreign bulletin' do
      bulletin = bulletins(:vehicle)
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph

      put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })
      bulletin.reload

      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { bulletin.title != title }
      assert { bulletin.description != description }
    end

    test 'should not update bulletin for unauthenticated user' do
      sign_out
      bulletin = bulletins(:music)
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph

      put(bulletin_url(bulletin), params: { bulletin: { title: title, description: description } })
      bulletin.reload

      assert_response(:redirect)
      assert_redirected_to(root_url)
      assert { bulletin.title != title }
      assert { bulletin.description != description }
    end
  end
end
