# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:alice) { User.create!(email: 'alice@example.com', password: 'password') }
  let(:bob) { User.create!(email: 'bob@example.com', password: 'password') }
  let(:report) do
    Report.create!(user: alice, title: 'タイトル', content: '内容',
                   created_at: Time.zone.local(2025, 1, 2, 3, 4, 5))
  end

  describe '#editable?' do
    it '日報の作成者ならtrueを返す' do
      expect(report.editable?(alice)).to be true
    end

    it '日報の作成者以外ならfalseを返す' do
      expect(report.editable?(bob)).to be false
    end
  end

  describe '#created_on' do
    it '作成日時を日付(Date)で返す' do
      expect(report.created_on).to eq Date.new(2025, 1, 2)
    end
  end
end
