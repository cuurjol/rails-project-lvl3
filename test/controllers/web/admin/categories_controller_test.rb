# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    # rubocop:disable Metrics/ClassLength
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        sign_in(@admin)
      end

      test 'should get a list of categories' do
        get(admin_categories_url)
        assert_response(:success)
      end

      test 'failed admin authorization to view a list of categories' do
        assert_no_admin_authorization do
          sign_out
          get(admin_categories_url)
        end
      end

      test 'should get a creating form of category' do
        get(new_admin_category_url)
        assert_response(:success)
      end

      test 'failed admin authorization to view a creating form of category' do
        assert_no_admin_authorization do
          sign_out
          get(new_admin_category_url)
        end
      end

      test 'should create a new category' do
        assert_difference(-> { Category.count }) do
          params = { category: { name: Faker::Types.rb_string.capitalize } }
          post(admin_categories_url, params: params)

          assert_response(:redirect)
          assert_redirected_to(admin_categories_url)
          assert { Category.exists?(name: params[:category][:name]) }
          assert { flash[:notice] == I18n.t('web.admin.categories.create.success') }
        end
      end

      test 'should not create a new category due to validation errors' do
        assert_no_difference(-> { Category.count }) do
          post(admin_categories_url, params: { category: { name: '' } })

          assert_response(:unprocessable_entity)
          assert { flash[:alert] == I18n.t('web.admin.categories.create.failure') }
        end
      end

      test 'failed admin authorization to create a new category' do
        assert_no_difference(-> { Category.count }) do
          assert_no_admin_authorization do
            sign_out
            post(admin_categories_url, params: { category: { name: Faker::Types.rb_string.capitalize } })
          end
        end
      end

      test 'should get an editing form of category' do
        get(edit_admin_category_url(categories(:music)))
        assert_response(:success)
      end

      test 'failed admin authorization to view an editing form of category' do
        assert_no_admin_authorization do
          sign_out
          get(edit_admin_category_url(categories(:music)))
        end
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

      test 'should not update an existing category due to validation errors' do
        category = categories(:music)

        assert_no_changes(-> { category.reload.name }) do
          put(admin_category_url(category), params: { category: { name: '' } })

          assert_response(:unprocessable_entity)
          assert { flash[:alert] == I18n.t('web.admin.categories.update.failure') }
        end
      end

      test 'failed admin authorization to update an existing category' do
        category = categories(:music)
        name = Faker::Types.rb_string.capitalize

        assert_no_changes(-> { category.reload.name }) do
          assert_no_admin_authorization do
            sign_out
            put(admin_category_url(category), params: { category: { name: name } })
          end
        end
      end

      test 'should destroy an existing category' do
        assert_difference(-> { Category.count }, -1) do
          delete(admin_category_url(categories(:music)))

          assert_response(:redirect)
          assert_redirected_to(admin_categories_url)
          assert { !Category.exists?(name: categories(:music).name) }
          assert { flash[:notice] == I18n.t('web.admin.categories.destroy.success') }
        end
      end

      test 'failed admin authorization to destroy an existing category' do
        assert_no_difference(-> { Category.count }) do
          assert_no_admin_authorization do
            sign_out
            delete(admin_category_url(categories(:music)))
          end
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
