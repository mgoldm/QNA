# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        @question = Question.find(params[:id])
        render json: @question
      end

      def create
        @question = current_resource_owner.questions.new(question_params)
        if @question.save
          render json: @question
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      def update
        @question = Question.find(params[:id])
        if @question.update(question_params)
          render json: @question
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @question = Question.find(params[:id])
        @question.destroy
        render json: @question
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, link_attributes: %i[name url])
      end
    end
  end
end
