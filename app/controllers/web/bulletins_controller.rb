# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    def index
      @search = Bulletin.includes(:category, image_attachment: :blob).published.ransack(params[:q])
      @bulletins = @search.result.order(created_at: :desc).page(params[:page]).per(12)
    end

    def show
      authorize(bulletin)
    end

    def new
      authorize(Bulletin)
      @bulletin = Bulletin.new
    end

    def edit
      authorize(bulletin)
    end

    def create
      authorize(Bulletin)
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to(@bulletin, notice: t('.success'))
      else
        flash.now.alert = t('.failure')
        render(:new, status: :unprocessable_entity)
      end
    end

    def update
      authorize(bulletin)

      if bulletin.update(bulletin_params)
        redirect_to(bulletin, notice: t('.success'))
      else
        flash.now.alert = t('.failure')
        render(:edit, status: :unprocessable_entity)
      end
    end

    def moderate
      authorize(bulletin)
      flash_message = bulletin.moderate! ? { notice: t('.success') } : { alert: t('.failure') }
      redirect_to(profile_path, flash_message)
    end

    def archive
      authorize(bulletin)
      flash_message = bulletin.archive! ? { notice: t('.success') } : { alert: t('.failure') }
      redirect_to(profile_path, flash_message)
    end

    def draft
      authorize(bulletin)
      flash_message = bulletin.to_draft! ? { notice: t('.success') } : { alert: t('.failure') }
      redirect_to(profile_path, flash_message)
    end

    private

    def bulletin
      @bulletin ||= Bulletin.find(params[:id])
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
