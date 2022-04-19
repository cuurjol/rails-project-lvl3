# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_bulletin, only: %i[show edit update]

    def index
      @search = Bulletin.includes(:user, :category).order(created_at: :desc).ransack(params[:q])
      @bulletins = @search.result
    end

    def show; end

    def new
      @bulletin = Bulletin.new
    end

    def edit; end

    def create
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to(@bulletin, notice: t('.success'))
      else
        render(:new)
      end
    end

    def update
      return redirect_to(root_path) unless @bulletin.user == current_user

      if @bulletin.update(bulletin_params)
        redirect_to(@bulletin, notice: t('.success'))
      else
        render(:edit)
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
