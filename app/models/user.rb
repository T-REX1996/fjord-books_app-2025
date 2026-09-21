# frozen_string_literal: true

class User < ApplicationRecord
  mount_uploader :icon, IconUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
