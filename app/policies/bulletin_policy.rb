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
    edit?
  end

  def archive?
    owner? && record.may_archive?
  end

  def draft?
    owner? && record.may_to_draft?
  end
end
