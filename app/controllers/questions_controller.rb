# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.all
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question was deleted successful'
    else
      redirect_to question_path(@question), alert: "You don't have permission"
    end
  end

  def delete_files
    @question = Question.with_attached_files.find(params[:question_id])

    if current_user.author_of?(@question)
      @question.files[params[:number].to_i].purge
      redirect_to question_path(@question)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
