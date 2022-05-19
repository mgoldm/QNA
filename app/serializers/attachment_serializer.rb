# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :body, :created_at
end
