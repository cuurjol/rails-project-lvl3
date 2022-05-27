# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      def index
        @search = Bulletin.includes(:user, :category).order(created_at: :desc).ransack(params[:q])
        @bulletins = @search.result.page(params[:page])
      end

      def destroy
        bulletin.destroy!
        redirect_to(admin_bulletins_path, notice: t('.success'))
      end

      def publish
        flash_message = bulletin.publish! ? { notice: t('.success') } : { alert: t('.failure') }
        redirect_to(admin_bulletins_path, flash_message)
      end

      def reject
        flash_message = bulletin.reject! ? { notice: t('.success') } : { alert: t('.failure') }
        redirect_to(admin_bulletins_path, flash_message)
      end

      def archive
        flash_message = bulletin.archive! ? { notice: t('.success') } : { alert: t('.failure') }
        redirect_to(admin_bulletins_path, flash_message)
      end

      private

      def bulletin
        @bulletin ||= Bulletin.find(params[:id])
      end
    end
  end
end
