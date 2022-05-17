# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :short_title

  has_many :answers
  has_many :links
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

end
