# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def best_answer
    answers.where(best: true).to_a
  end
end
