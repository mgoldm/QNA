# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  validates :title, :correct, presence: true

  def update_best!
    question.best_answer[0].update(best: false) if question.best_answer.present?
    update(best: true)
    user.rewards.push(question.reward)
  end
end
