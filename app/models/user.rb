# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 150]
  end

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid).tap do |user|
      next if user.persisted?

      user.email = auth.info.email
      user.name = auth.info.name.presence || auth.info.nickname
      user.save
    end
  end

  def name_or_email
    name.presence || email
  end

  protected

  # GitHub認証で登録したユーザーはパスワード未設定のため、パスワードの入力を求めない
  def password_required?
    return false if provider.present? && password.nil? && password_confirmation.nil?

    super
  end
end
