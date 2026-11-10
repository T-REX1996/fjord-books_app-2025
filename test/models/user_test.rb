# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email' do
    user = users(:komagata)
    assert_equal '駒形 真幸', user.name_or_email

    user.name = ''
    assert_equal 'komagata@example.com', user.name_or_email
  end

  test 'from_omniauth creates a user without a password' do
    auth = OmniAuth::AuthHash.new(
      provider: 'github', uid: '12345',
      info: { email: 'octocat@example.com', name: '', nickname: 'octocat' }
    )

    user = User.from_omniauth(auth)

    assert user.persisted?
    assert_equal 'octocat', user.name
    assert user.encrypted_password.blank?
    assert_equal user, User.from_omniauth(auth)
  end
end
