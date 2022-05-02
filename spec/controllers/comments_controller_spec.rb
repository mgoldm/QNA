# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:commentable) { create(:question, user: user) }
  let(:comment) { create(:comment, comment: '123', commentable: commentable) }
  let(:user) { create(:user) }

  before { sign_in(user) }
  describe 'POST #create' do
    it 'saves a new answer in the database' do
      expect do
        post :create,
             params: { comment: attributes_for(:comment), commentable_id: commentable.id, commentable_type: 'Question', format: :json }, as: :json
      end.to change(commentable.comments, :count).by(1)
    end
  end
end
