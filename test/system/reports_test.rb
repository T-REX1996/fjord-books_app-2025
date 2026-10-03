# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @alice = users(:alice)
    @alice_report = reports(:alice_report)
    @bob_report = reports(:bob_report)
  end

  test 'ログインしていないと日報一覧に入れずログイン画面に移動する' do
    visit reports_path

    assert_current_path new_user_session_path
  end

  test 'メールアドレスとパスワードでログインして日報を書く' do
    sign_in_with(@alice)

    click_link '日報', exact: true
    assert_selector 'h1', text: '日報の一覧'

    click_link '日報の新規作成'
    fill_in 'タイトル', with: '今日の日報'
    fill_in '内容', with: 'テストの書き方を学びました。'
    click_button '登録する'

    assert_text '日報が作成されました。'
    assert_text '今日の日報'
    assert_text 'テストの書き方を学びました。'
    assert_text @alice.name_or_email
    assert_text I18n.l(Time.zone.today)
  end

  test 'タイトルが空の日報は作成できない' do
    sign_in_with(@alice)
    visit new_report_path

    fill_in '内容', with: 'タイトルなしの内容'

    assert_no_difference 'Report.count' do
      click_button '登録する'
      assert_text 'タイトルを入力してください'
    end
    assert_no_text '日報が作成されました。'
    assert_selector 'h1', text: '日報の新規作成'
  end

  test '自分の日報を編集する' do
    sign_in_with(@alice)
    visit report_path(@alice_report)

    click_link 'この日報を編集'
    assert_selector 'h1', text: '日報の編集'
    fill_in 'タイトル', with: '編集後のタイトル'
    fill_in '内容', with: '編集後の内容です。'
    click_button '更新する'

    assert_text '日報が更新されました。'
    assert_text '編集後のタイトル'
    assert_text '編集後の内容です。'
    assert_no_text 'Aliceの日報'
  end

  test '自分の日報を削除する' do
    sign_in_with(@alice)
    visit report_path(@alice_report)

    assert_difference 'Report.count', -1 do
      click_button 'この日報を削除'
      assert_text '日報が削除されました。'
    end

    assert_current_path reports_path
    assert_no_text 'Aliceの日報'
    assert_text 'Bobの日報'
  end

  test '他のユーザの日報には編集と削除の操作が表示されない' do
    sign_in_with(@alice)
    visit report_path(@bob_report)

    assert_text 'Bobの日報'
    assert_no_link 'この日報を編集'
    assert_no_button 'この日報を削除'
  end
end
