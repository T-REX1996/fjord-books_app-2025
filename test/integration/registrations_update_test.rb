# frozen_string_literal: true

require 'test_helper'

class RegistrationsUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:komagata)
    sign_in @user
  end

  test 'profile can be updated without the current password' do
    put user_registration_path, params: { user: { name: '新しい名前', email: @user.email } }

    assert_equal '新しい名前', @user.reload.name
  end

  test 'email cannot be changed without the current password' do
    put user_registration_path, params: { user: { email: 'new@example.com' } }

    assert_equal 'komagata@example.com', @user.reload.email
  end

  test 'email can be changed with the current password' do
    put user_registration_path, params: { user: { email: 'new@example.com', current_password: 'password' } }

    assert_equal 'new@example.com', @user.reload.email
  end

  test 'password cannot be changed without the current password' do
    put user_registration_path, params: { user: { password: 'newpassword', password_confirmation: 'newpassword' } }

    assert @user.reload.valid_password?('password')
  end
end
