# frozen_string_literal: true

module Admin
  class BulletinPolicy < ApplicationPolicy
    %i[index? show? destroy? publish? reject? archive?].each do |method_name|
      case method_name
      when :publish? then define_method(method_name) { admin? && record.may_publish? }
      when :reject? then define_method(method_name) { admin? && record.may_reject? }
      when :archive? then define_method(method_name) { admin? && record.may_archive? }
      else define_method(method_name) { admin? }
      end
    end
  end
end
