# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_URL_PATTERN = %r{http://localhost:3000/reports/(\d+)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relations, class_name: 'ReportMention', foreign_key: :mentioning_report_id,
                                  dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :mentioning_relations, source: :mentioned_report

  has_many :mentioned_relations, class_name: 'ReportMention', foreign_key: :mentioned_report_id,
                                 dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :mentioned_relations, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_with_mentions!
    transaction do
      save!
      update_mentions!
    end
  end

  private

  def mentioning_report_ids_in_content
    content.scan(REPORT_URL_PATTERN).flatten.map(&:to_i).uniq - [id]
  end

  def update_mentions!
    self.mentioning_reports = Report.where(id: mentioning_report_ids_in_content)
  end
end
