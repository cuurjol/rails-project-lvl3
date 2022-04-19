# frozen_string_literal: true

module Web
  class BulletinContactsController < ApplicationController
    invisible_captcha only: :create

    def create
      @bulletin_contact = BulletinContact.new(bulletin_contact)

      if @bulletin_contact.deliver
        redirect_to(@bulletin_contact.bulletin, notice: t('.success'))
      else
        redirect_to(@bulletin_contact.bulletin, alert: t('.failure'))
      end
    end

    private

    def bulletin_contact
      params.require(:bulletin_contact).permit(:name, :email, :message, :bulletin_id, :owner_email)
    end
  end
end
