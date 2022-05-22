# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable

  belongs_to :user

  has_many :subscribers
  has_many :subs, through: :subscribers, source: :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :send_notification

  def best_answer
    answers.where(best: true).to_a
  end

  def check_date
    created_at.day == Time.now.day and created_at.month == Time.now.month and created_at.year == Time.now.year
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
