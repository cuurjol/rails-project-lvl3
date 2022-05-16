# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < ApplicationController
      before_action :check_admin_authorize
      before_action :set_category, only: %i[edit update destroy]

      def index
        @search = Category.ransack(params[:q])
        @categories = @search.result.page(params[:page])
      end

      def new
        @category = Category.new
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          redirect_to(admin_categories_path, notice: t('.success'))
        else
          flash.now.alert = t('.failure')
          render(:new)
        end
      end

      def edit; end

      def update
        if @category.update(category_params)
          redirect_to(admin_categories_path, notice: t('.success'))
        else
          flash.now.alert = t('.failure')
          render(:edit)
        end
      end

      def destroy
        @category.destroy!
        redirect_to(admin_categories_path, notice: t('.success'))
      end

      private

      def check_admin_authorize
        authorize(Category)
      end

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
