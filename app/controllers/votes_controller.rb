# frozen_string_literal: true

class VotesController < ApplicationController
  def vote
    @answer = Answer.find(params[:votable_id])

    if @answer.voted?(current_user)
      old_vote = @answer.votes.find_by(user: current_user)
      old_vote.delete
    end

    @vote = @answer.votes.new(action: params[:number])
    current_user.votes.push(@vote)

    respond_to do |format|
      @vote.save
      format.json { render json: { vote: @vote, answer_count: @answer.counter } }
    end
  end
end
