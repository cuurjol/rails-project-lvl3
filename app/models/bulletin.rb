# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  aasm whiny_transitions: false, column: :state do
    state :draft, initial: true
    state :under_moderation, :published, :rejected, :archived

    event :moderate do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end

    event :to_draft do
      transitions from: :published, to: :draft
    end
  end

  belongs_to :user
  belongs_to :category
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than_or_equal_to: 5.megabytes }
end
