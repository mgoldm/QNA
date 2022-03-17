# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer, question_id: create(:question).id) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'render show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'render new view' do
      get :new, params: { question_id: answer.question_id }
      expect(response).to render_template(:new)
    end
  end

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
               params: { answer: attributes_for(:answer), question_id: answer.question_id }
        end.to change(answer.question.answers, :count).by(1)
      end

      it 'renders answer template' do
        post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: answer.question_id }
        end.to_not change(answer.question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: answer.question_id }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: answer.question_id }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { title: 'new title', correct: true } }
        answer.reload

        expect(answer.title).to eq 'new title'
        expect(answer.correct).to eq true
      end

      it 'redirect to updated answer' do
        patch :update,
              params: { question_id: answer.question_id, id: answer, answer: { title: 'new title', correct: true } }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: { question_id: answer.question_id, id: answer, answer: attributes_for(:answer, :invalid) }
      end
      it 'does not change answer' do
        answer.reload

        expect(answer.title).to eq 'MyString'
        expect(answer.correct).to eq true
      end

      it 're-renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, title: '123', correct: true, question_id: create(:question).id) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
