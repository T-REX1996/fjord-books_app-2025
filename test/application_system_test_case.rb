# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  class << self
    attr_accessor :browser_warmed_up
  end

  # 実行内で最初に動くシステムテストだけ、ページ表示後のクリックが取りこぼされることがあるため、
  # 最初に一度だけブラウザを操作してならしておく（環境依存の回避策）
  setup do
    next if ApplicationSystemTestCase.browser_warmed_up

    ApplicationSystemTestCase.browser_warmed_up = true
    warm_up_browser
  end

  private

  def warm_up_browser
    sign_in_with(users(:alice))
    visit reports_path
    assert_selector 'h1'
  rescue Minitest::Assertion, Capybara::ElementNotFound
    # ならしが目的なので、失敗しても無視する
  ensure
    Capybara.reset_sessions!
  end

  # 画面からメールアドレスとパスワードを入力してログインする
  def sign_in_with(user, password: 'password')
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: password
    click_button I18n.t('devise.sessions.new.sign_in')

    assert_text I18n.t('layouts.menu.sign_in_as', user: user.name_or_email)
  end
end
