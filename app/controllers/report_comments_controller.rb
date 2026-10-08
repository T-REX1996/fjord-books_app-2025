# frozen_string_literal: true

class ReportCommentsController < ApplicationController
  before_action :set_report

  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @report, alert: @comment.errors.full_messages.join(', ')
    end
  end

  private

  def set_report
    @report = Report.find(params.expect(:report_id))
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
