# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:answer) { create(:answer, question_id: create(:question).id) }
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'POST #vote' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :vote,
               params: { votable_id: answer, votable: answer.class.name, action: 1 }, format: :json
        end.to change(answer.votes, :count).by(1)
      end
    end
  end
end
