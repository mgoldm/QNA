# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create ]

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers.push(@answer)

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created'
    else
      redirect_to question_path(@question), alert: 'Invalid values'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'Answer was deleted successful'
    else
      redirect_to question_path(answer.question), alert: "You don't have permission"
    end
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
    params.require(:answer).permit(:title, :correct)
  end
end
