# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :short_title
  has_many :answers

  def short_title
    object.title.truncate(7)
  end
  # belongs_to :user
end
