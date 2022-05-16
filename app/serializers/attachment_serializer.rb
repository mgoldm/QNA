class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :body, :created_at
end
