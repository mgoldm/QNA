# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :user_id, :created_at, :updated_at
end
