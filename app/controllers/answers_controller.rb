# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]

  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers.push(@answer)

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    answer.update(answer_params)
  end

  def update_best
    answer.update_best! if current_user.author_of?(answer.question)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{answer.question_id}/answers",
      {
        answer: ApplicationController.render(
          partial: 'answers/answer',
          locals: {
            answer: answer, current_user: current_user
          }
        ),
        answer_id: answer.id,
        answer_author_id: answer.user_id,
        question_author_id: answer.question.user_id
      }
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:title, :correct, :best, files: [], links_attributes: %i[name url])
  end
end
