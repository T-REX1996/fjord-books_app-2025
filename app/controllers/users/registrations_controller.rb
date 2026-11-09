# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # パスワードまたはメールアドレスを変更する場合のみ現在のパスワードを要求する
  def update_resource(resource, params)
    if resource.encrypted_password.present? && credentials_changed?(resource, params)
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  end

  private

  def credentials_changed?(resource, params)
    params[:password].present? || (params[:email].present? && params[:email] != resource.email)
  end
end
