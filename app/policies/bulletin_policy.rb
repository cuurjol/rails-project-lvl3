# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    new?
  end

  def show?
    admin? || owner? || record.published?
  end

  def edit?
    owner? && record.may_moderate?
  end

  def update?
    edit?
  end

  def moderate?
    owner?
  end

  def archive?
    moderate?
  end

  def draft?
    moderate?
  end
end
