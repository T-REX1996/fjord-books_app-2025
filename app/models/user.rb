# frozen_string_literal: true

class User < ApplicationRecord
  ALLOWED_ICON_TYPES = %w[image/jpeg image/png image/gif].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :icon do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validate :icon_content_type

  private

  def icon_content_type
    return unless icon.attached?
    return if ALLOWED_ICON_TYPES.include?(icon.blob.content_type)

    errors.add(:icon, :invalid_content_type)
  end
end
