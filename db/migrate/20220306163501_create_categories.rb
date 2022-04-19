# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, limit: 30, null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
