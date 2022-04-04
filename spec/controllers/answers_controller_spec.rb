# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer, question_id: create(:question).id) }
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #edit' do
    it 'render edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer), question_id: answer.question_id, format: :js }
        end.to change(answer.question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: answer.question_id, format: :js }
        end.to_not change(answer.question.answers, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: answer.question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer), question_id: answer.question_id, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { title: 'new title', correct: 'true' }, format: :js }
        answer.reload

        expect(answer.title).to eq 'new title'
        expect(answer.correct).to eq 'true'
      end

      it 'redirect to updated answer' do
        patch :update,
              params: { question_id: answer.question_id, id: answer, answer: { title: 'new title', correct: 'true' },
                        format: :js }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: { question_id: answer.question_id, id: answer, answer: attributes_for(:answer, :invalid),
                        format: :js }
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.title).to eq 'MyString'
        expect(answer.correct).to eq 'true'
      end

      it 're-renders edit' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author delete' do
      before { sign_in(user) }
      let!(:answer) { create(:answer, title: '123', correct: 'true', user_id: user.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user DELETE' do
      let(:another_user) { create(:user) }
      before { login(another_user) }
      let!(:answer) { create(:answer) }

      it 'delete question' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'redirect to show question' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
