# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        sign_in(@admin)
      end

      test 'should get a list of categories' do
        get(admin_categories_url)
        assert_response(:success)
        assert_select('h2', I18n.t('web.admin.categories.index.main_title'))
      end

      test 'should get a creating form of category' do
        get(new_admin_category_url)
        assert_response(:success)
        assert_select('h2', I18n.t('web.admin.categories.new.main_title'))
      end

      test 'should create a new category' do
        assert_difference(-> { Category.count }) do
          post(admin_categories_url, params: { category: { name: Faker::Types.rb_string.capitalize } })

          assert_response(:redirect)
          assert_redirected_to(admin_categories_url)
          assert { flash[:notice] == I18n.t('web.admin.categories.create.success') }
        end
      end

      test 'should not create a new category' do
        assert_no_difference(-> { Category.count }) do
          post(admin_categories_url, params: { category: { name: '' } })

          assert_response(:success)
          assert { flash[:alert] == I18n.t('web.admin.categories.create.failure') }
        end
      end

      test 'should get an editing form of category' do
        get(edit_admin_category_url(categories(:music)))
        assert_response(:success)
        assert_select('h2', I18n.t('web.admin.categories.edit.main_title'))
      end

      test 'should update an existing category' do
        category = categories(:music)
        name = Faker::Types.rb_string.capitalize

        assert_changes(-> { category.reload.name }, to: name) do
          put(admin_category_url(category), params: { category: { name: name } })

          assert_response(:redirect)
          assert_redirected_to(admin_categories_url)
          assert { flash[:notice] == I18n.t('web.admin.categories.update.success') }
        end
      end

      test 'should not update an existing category' do
        category = categories(:music)

        assert_no_changes(-> { category.reload.name }) do
          put(admin_category_url(category), params: { category: { name: '' } })

          assert_response(:success)
          assert { flash[:alert] == I18n.t('web.admin.categories.update.failure') }
        end
      end

      test 'should destroy an existing category' do
        assert_difference(-> { Category.count }, -1) do
          delete(admin_category_url(categories(:music)))

          assert_response(:redirect)
          assert_redirected_to(admin_categories_url)
          assert { flash[:notice] == I18n.t('web.admin.categories.destroy.success') }
        end
      end

      test 'should not destroy an existing category for anonymous user' do
        assert_no_difference(-> { Category.count }) do
          sign_out
          delete(admin_category_url(categories(:music)))

          assert_response(:redirect)
          assert_redirected_to(root_url)
          assert { flash[:alert] == I18n.t('pundit.admin/category_policy.destroy?') }
        end
      end
    end
  end
end
