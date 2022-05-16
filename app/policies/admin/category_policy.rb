# frozen_string_literal: true

module Admin
  class CategoryPolicy < ApplicationPolicy
    %i[index? new? create? edit? update? destroy?].each { |method_name| define_method(method_name) { admin? } }
  end
end
