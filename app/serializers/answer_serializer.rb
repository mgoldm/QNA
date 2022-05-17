# frozen_string_literal: true

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :correct, :best, :user_id, :created_at, :updated_at, :short_title

  has_many :links
  has_many :comments
  has_many :files, serializer: AttachmentSerializer

end

