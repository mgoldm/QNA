# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      def create
        @question = Question.find(params[:question_id])
        @answer = @question.answers.new(answer_params)
        current_resource_owner.answers.push(@answer)
        if @answer.save
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      def update
        @answer = Answer.find(params[:id])
        if @answer.update(answer_params)
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @answer = Answer.find(params[:id])
        @question = @answer.question
        @answer.destroy
        render json: @question
      end

      private

      def answer_params
        params.require(:answer).permit(:title, :correct, :best, files: [], links_attributes: %i[name url])
      end
    end
  end
end
