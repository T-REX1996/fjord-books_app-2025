# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
  end

  test 'valid with body, user and commentable' do
    assert @comment.valid?
  end

  test 'invalid without body' do
    @comment.body = nil
    assert_not @comment.valid?
  end

  test 'invalid without user' do
    @comment.user = nil
    assert_not @comment.valid?
  end

  test 'invalid without commentable' do
    @comment.commentable = nil
    assert_not @comment.valid?
  end

  test 'belongs to user' do
    assert_equal users(:one), @comment.user
  end

  test 'commentable can be a book' do
    assert_equal books(:one), @comment.commentable
  end

  test 'commentable can be a report' do
    report_comment = comments(:two)
    assert_equal reports(:one), report_comment.commentable
  end
end
