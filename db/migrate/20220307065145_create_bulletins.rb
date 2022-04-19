# frozen_string_literal: true

class CreateBulletins < ActiveRecord::Migration[6.1]
  def change
    create_table :bulletins do |t|
      t.string :title, limit: 50, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.check_constraint 'length(description) <= 1000', name: 'description_length_check'

      t.timestamps
    end
  end
end
