# frozen_string_literal: true

module Web
  class ProfilesController < ApplicationController
    def show
      authorize([:profile, Bulletin])
      @search = current_user.bulletins.includes(:category).order(created_at: :desc).ransack(params[:q])
      @bulletins = @search.result.page(params[:page])
    end
  end
end
