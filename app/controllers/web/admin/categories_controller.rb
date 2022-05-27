# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < ApplicationController
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
          render(:new, status: :unprocessable_entity)
        end
      end

      def edit
        @category = Category.find(params[:id])
      end

      def update
        @category = Category.find(params[:id])

        if @category.update(category_params)
          redirect_to(admin_categories_path, notice: t('.success'))
        else
          flash.now.alert = t('.failure')
          render(:edit, status: :unprocessable_entity)
        end
      end

      def destroy
        @category = Category.find(params[:id])
        @category.destroy!
        redirect_to(admin_categories_path, notice: t('.success'))
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
