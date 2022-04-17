# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  validates :title, :correct, presence: true

  def update_best(old_best)
    question.best_answer.find(old_best.id).update(best: false) if question.best_answer.count>1
    user.rewards.push(question.reward) if old_best != question.best_answer
  end
end
