# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  def create
    @comment = current_user.comments.new(comment: params[:comment],
                                         commentable_type: params[:commentable_type],
                                         commentable_id: params[:commentable_id])

    respond_to do |format|
      @comment.save
      format.json do
        render json: { comments: @comment,
                       comment: @comment.comment,
                       commentable_type: @comment.commentable_type,
                       commentable_id: @comment.commentable_id }
      end
    end
  end

  private

  def publish_answer
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      'comments',
      {
        comment: ApplicationController.render(
          partial: 'comments/comm',
          locals: {
            comment: @comment
          }
        ),
        commentable_id: @comment.commentable.id,
        commentable_author_id: @comment.commentable.user_id,
        commentable_type: @comment.commentable_type
      }
    )
  end
end
