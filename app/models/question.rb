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

  after_create :calculate_reputation

  def self.check_date
    where(created_at: Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
  end

  def best_answer
    answers.where(best: true).to_a
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
