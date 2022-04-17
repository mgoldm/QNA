# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers.push(@answer)
    @answer.save
  end

  def update
    @question = answer.question
    old_best = @question.best_answer

    answer.update(answer_params)

    answer.update_best(old_best) if current_user.author_of?(@question)

  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

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
