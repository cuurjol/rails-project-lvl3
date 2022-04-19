# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
end
