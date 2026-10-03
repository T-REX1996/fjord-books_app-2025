# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @alice_report = reports(:alice_report)
    @bob_report = reports(:bob_report)
  end

  test 'タイトルが空だと無効' do
    report = Report.new(user: @alice, title: '', content: '内容')

    assert_not report.valid?
    assert report.errors.of_kind?(:title, :blank)
  end

  test '内容が空だと無効' do
    report = Report.new(user: @alice, title: 'タイトル', content: '')

    assert_not report.valid?
    assert report.errors.of_kind?(:content, :blank)
  end

  test '#editable? は作成者本人ならtrueを返す' do
    assert @alice_report.editable?(@alice)
  end

  test '#editable? は作成者以外ならfalseを返す' do
    assert_not @alice_report.editable?(@bob)
  end

  test '#created_on は作成日時の日付を返す' do
    report = Report.new(created_at: Time.zone.local(2026, 10, 3, 23, 59, 59))

    assert_equal Date.new(2026, 10, 3), report.created_on
  end

  test '#created_on はアプリのタイムゾーン(Tokyo)での日付を返す' do
    # UTCでは10/3 15:30だが、Tokyoでは10/4 00:30
    report = Report.new(created_at: Time.utc(2026, 10, 3, 15, 30))

    assert_equal Date.new(2026, 10, 4), report.created_on
  end

  test '本文に他の日報のURLがあると言及として保存される' do
    report = @alice.reports.create!(title: '言及あり', content: "参考: http://localhost:3000/reports/#{@bob_report.id}")

    assert_equal [@bob_report], report.mentioning_reports
    assert_equal [report], @bob_report.reload.mentioned_reports
  end

  test '同じ日報のURLが複数あっても言及は1件だけ保存される' do
    url = "http://localhost:3000/reports/#{@bob_report.id}"
    report = @alice.reports.create!(title: '重複', content: "#{url} と #{url}")

    assert_equal 1, report.mentioning_reports.count
  end

  test '自分自身のURLは言及として保存されない' do
    @alice_report.update!(content: "http://localhost:3000/reports/#{@alice_report.id}")

    assert_empty @alice_report.mentioning_reports
  end

  test '存在しない日報のURLは言及として保存されない' do
    report = @alice.reports.create!(title: '存在しない', content: 'http://localhost:3000/reports/0')

    assert_empty report.mentioning_reports
  end

  test '内容を更新すると言及が差し替わる' do
    report = @alice.reports.create!(title: '差し替え', content: "http://localhost:3000/reports/#{@bob_report.id}")
    assert_equal [@bob_report], report.mentioning_reports

    report.update!(content: "http://localhost:3000/reports/#{@alice_report.id}")

    assert_equal [@alice_report], report.reload.mentioning_reports
  end

  test 'URLを削除して更新すると言及が解除される' do
    report = @alice.reports.create!(title: '解除', content: "http://localhost:3000/reports/#{@bob_report.id}")

    report.update!(content: '言及なし')

    assert_empty report.reload.mentioning_reports
  end
end
