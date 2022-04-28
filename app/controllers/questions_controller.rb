# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy ]
  before_action :gon_question, except: %i[index new]

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @question.links.new
    @answers = @question.answers.all
    @answer = @question.answers.new
    @answer.links.build
    @answer.votes.build
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new(question: @question)
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

  private

  def gon_question
    gon.question_id = @question.id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions',
                                 ApplicationController.render(partial: 'questions/question',
                                                              locals: { question: @question })
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                     reward_attributes: %i[name image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
