# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  scope :admin, -> { where(admin: true) }
  scope :not_admin, -> { where.not(admin: true) }

  class << self
    def authenticate(email:, password:)
      User.find_by(email: email)&.authenticate(password)
    end

    def find_or_create_with_omniauth(auth)
      password = SecureRandom.uuid
      params = { name: auth.info.name, password: password, password_confirmation: password }
      User.create_with(params).find_or_create_by(email: auth.info.email.downcase)
    end
  end
end
