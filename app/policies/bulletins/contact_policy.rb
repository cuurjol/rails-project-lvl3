# frozen_string_literal: true

module Bulletins
  class ContactPolicy < ApplicationPolicy
    def create?
      record.bulletin.published?
    end
  end
end
