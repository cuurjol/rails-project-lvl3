# frozen_string_literal: true

class RemoveConstraintForPasswordFromUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:users, :password_digest, true)
  end
end
