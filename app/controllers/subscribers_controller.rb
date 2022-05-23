class SubscribersController < ApplicationController
  before_action :authenticate_user!

  def create
    @subscribe = current_user.subscribers.new(question_id: params[:question_id])
    if @subscribe.save
      redirect_to @subscribe.question
    end
  end

  def destroy
    @subscribe = current_user.subscribers.find_by(question_id: params[:question_id])
    @subscribe.destroy
  end
end
