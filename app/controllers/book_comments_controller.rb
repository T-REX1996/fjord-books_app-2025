# frozen_string_literal: true

class BookCommentsController < ApplicationController
  before_action :set_book

  def create
    @comment = @book.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @book, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @book, alert: @comment.errors.full_messages.join(', ')
    end
  end

  private

  def set_book
    @book = Book.find(params.expect(:book_id))
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
