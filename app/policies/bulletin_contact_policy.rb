# frozen_string_literal: true

class BulletinContactPolicy < ApplicationPolicy
  def create?
    record.bulletin.published?
  end
end
