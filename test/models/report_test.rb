# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report = reports(:one)
  end

  test 'valid with title, body and user' do
    assert @report.valid?
  end

  test 'invalid without title' do
    @report.title = nil
    assert_not @report.valid?
  end

  test 'invalid without body' do
    @report.body = nil
    assert_not @report.valid?
  end

  test 'invalid without user' do
    @report.user = nil
    assert_not @report.valid?
  end

  test 'belongs to user' do
    assert_equal users(:one), @report.user
  end
end
