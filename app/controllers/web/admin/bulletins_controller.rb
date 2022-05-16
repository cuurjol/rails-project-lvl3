# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :set_bulletin, only: %i[show destroy publish reject archive]

      def index
        authorize(Bulletin)
        @search = Bulletin.includes(:user, :category).order(created_at: :desc).ransack(params[:q])
        @bulletins = @search.result.page(params[:page])
      end

      def show
        render('web/bulletins/show')
      end

      def destroy
        @bulletin.destroy!
        redirect_to(admin_bulletins_path, notice: t('.success'))
      end

      def publish
        @bulletin.publish!
        redirect_to(admin_bulletins_path, notice: t('.success'))
      end

      def reject
        @bulletin.reject!
        redirect_to(admin_bulletins_path, notice: t('.success'))
      end

      def archive
        @bulletin.archive!
        redirect_to(admin_bulletins_path, notice: t('.success'))
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
        authorize(@bulletin)
      end
    end
  end
end
