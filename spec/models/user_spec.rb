# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    it '名前があれば名前を返す' do
      user = User.new(email: 'alice@example.com', name: 'alice')
      expect(user.name_or_email).to eq 'alice'
    end

    it '名前がなければメールアドレスを返す' do
      user = User.new(email: 'alice@example.com', name: '')
      expect(user.name_or_email).to eq 'alice@example.com'
    end
  end
end
