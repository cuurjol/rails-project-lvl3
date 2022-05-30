# frozen_string_literal: true

module Web
  module Admin
    class UsersController < ApplicationController
      def index
        @search = User.all_except(current_user).order(created_at: :desc).ransack(params[:q])
        @users = @search.result.page(params[:page])
      end

      def edit
        user
      end

      def update
        if user.update(user_params)
          redirect_to(admin_users_path, notice: t('.success'))
        else
          flash.now.alert = t('.failure')
          render(:edit, status: :unprocessable_entity)
        end
      end

      def destroy
        if user == current_user
          redirect_to(admin_users_path, alert: t('.failure'))
        else
          user.destroy!
          redirect_to(admin_users_path, notice: t('.success'))
        end
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :admin)
      end
    end
  end
end
