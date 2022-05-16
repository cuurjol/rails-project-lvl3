# frozen_string_literal: true

module Profile
  class BulletinPolicy < ApplicationPolicy
    def show?
      user.present?
    end
  end
end
