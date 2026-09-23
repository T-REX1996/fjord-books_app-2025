# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment
  before_action :ensure_owner!

  def destroy
    commentable = @comment.commentable
    @comment.destroy!
    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params.expect(:id))
  end

  def ensure_owner!
    return if @comment.user == current_user

    redirect_to @comment.commentable, alert: t('controllers.comments.forbidden')
  end
end
