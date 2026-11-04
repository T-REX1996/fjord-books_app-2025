# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  let(:alice) { User.create!(email: 'alice@example.com', password: 'password', name: 'alice') }
  let(:bob) { User.create!(email: 'bob@example.com', password: 'password', name: 'bob') }
  let(:report_name) { Report.model_name.human }

  before do
    driven_by(:rack_test)
    sign_in alice
  end

  describe '日報の一覧' do
    it '日報のタイトルが表示される' do
      Report.create!(user: alice, title: '一覧に出る日報', content: '内容')

      visit reports_path

      expect(page).to have_content '一覧に出る日報'
    end
  end

  describe '日報の作成' do
    it '日報を作成できる' do
      visit new_report_path
      fill_in Report.human_attribute_name(:title), with: '新しい日報'
      fill_in Report.human_attribute_name(:content), with: '今日やったこと'
      click_button I18n.t('helpers.submit.create')

      expect(page).to have_content I18n.t('controllers.common.notice_create', name: report_name)
      expect(page).to have_content '新しい日報'
      expect(page).to have_content '今日やったこと'
    end

    it 'タイトルが空だと作成できない' do
      visit new_report_path
      fill_in Report.human_attribute_name(:content), with: '内容だけ'
      click_button I18n.t('helpers.submit.create')

      expect(page).to have_no_content I18n.t('controllers.common.notice_create', name: report_name)
      expect(Report.count).to eq 0
    end
  end

  describe '日報の編集' do
    it '自分の日報を編集できる' do
      report = Report.create!(user: alice, title: '編集前', content: '編集前の内容')

      visit report_path(report)
      click_link I18n.t('views.common.edit', name: report_name.downcase)
      fill_in Report.human_attribute_name(:title), with: '編集後'
      click_button I18n.t('helpers.submit.update')

      expect(page).to have_content I18n.t('controllers.common.notice_update', name: report_name)
      expect(page).to have_content '編集後'
    end
  end

  describe '日報の削除' do
    it '自分の日報を削除できる' do
      report = Report.create!(user: alice, title: '消す日報', content: '内容')

      visit report_path(report)
      click_button I18n.t('views.common.destroy', name: report_name.downcase)

      expect(page).to have_content I18n.t('controllers.common.notice_destroy', name: report_name)
      expect(page).to have_no_content '消す日報'
    end
  end

  describe '他人の日報' do
    it '編集・削除のボタンが表示されない' do
      report = Report.create!(user: bob, title: 'bobの日報', content: '内容')

      visit report_path(report)

      expect(page).to have_content 'bobの日報'
      expect(page).to have_no_link I18n.t('views.common.edit', name: report_name.downcase)
      expect(page).to have_no_button I18n.t('views.common.destroy', name: report_name.downcase)
    end
  end
end
