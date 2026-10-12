# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email は名前があれば名前を返す' do
    user = User.new(email: 'alice@example.com', name: 'Alice')

    assert_equal 'Alice', user.name_or_email
  end

  test '#name_or_email は名前がnilならメールアドレスを返す' do
    user = User.new(email: 'bob@example.com', name: nil)

    assert_equal 'bob@example.com', user.name_or_email
  end

  test '#name_or_email は名前が空文字ならメールアドレスを返す' do
    user = User.new(email: 'bob@example.com', name: '')

    assert_equal 'bob@example.com', user.name_or_email
  end

  test '#name_or_email は名前が空白のみの場合は空白をそのまま返さずメールアドレスを返す' do
    user = User.new(email: 'bob@example.com', name: '   ')

    assert_equal 'bob@example.com', user.name_or_email
  end
end
