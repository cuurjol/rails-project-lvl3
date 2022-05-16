# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :set_bulletin, only: %i[show edit update moderate archive draft]

    def index
      @search = Bulletin.includes(:category, image_attachment: :blob).published.ransack(params[:q])
      @bulletins = @search.result.order(created_at: :desc).page(params[:page]).per(12)
    end

    def show; end

    def new
      authorize(Bulletin)
      @bulletin = Bulletin.new
    end

    def edit; end

    def create
      authorize(Bulletin)
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to(@bulletin, notice: t('.success'))
      else
        flash.now.alert = t('.failure')
        render(:new)
      end
    end

    def update
      if @bulletin.update(bulletin_params)
        redirect_to(@bulletin, notice: t('.success'))
      else
        flash.now.alert = t('.failure')
        render(:edit)
      end
    end

    def moderate
      @bulletin.moderate!
      redirect_to(profile_path, notice: t('.success'))
    end

    def archive
      @bulletin.archive!
      redirect_to(profile_path, notice: t('.success'))
    end

    def draft
      @bulletin.to_draft!
      redirect_to(profile_path, notice: t('.success'))
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
      authorize(@bulletin)
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
