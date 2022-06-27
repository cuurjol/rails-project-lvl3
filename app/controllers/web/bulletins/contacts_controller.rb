# frozen_string_literal: true

module Web
  module Bulletins
    class ContactsController < ApplicationController
      invisible_captcha only: :create

      def create
        @contact = ::Bulletins::Contact.new(contact_params)
        authorize(@contact)

        if @contact.deliver
          redirect_to(@contact.bulletin, notice: t('.success'))
        else
          redirect_to(@contact.bulletin, alert: t('.failure'))
        end
      end

      private

      def contact_params
        params.require(:bulletins_contact).permit(:name, :email, :message, :bulletin_id)
      end
    end
  end
end
