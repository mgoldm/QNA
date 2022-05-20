# frozen_string_literal: true

require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'aplication/json' }
  end

  it_behaves_like 'API Authorizable' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let!(:user_id) { access_token.resource_owner_id }
    let(:question) { create(:question, user_id: user_id) }
    let!(:answers) { create_list(:answer, 3, question: question, user_id: user_id) }
    let(:answer) { answers.first }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    describe 'Post' do
      it 'should create new' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer), access_token: access_token.token }

        expect(Answer.count).to eq 3
      end

      it 'ivalid create' do
        post "/api/v1/questions/#{question.id}/answers",
             params: { answer: attributes_for(:answer, correct: ''), access_token: access_token.token }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'Patch' do
      it 'should update answer' do
        patch "/api/v1/answers/#{answer.id}", params: { answer: { title: '123' }, access_token: access_token.token }

        answer.reload
        expect(json['answer']['title']).to eq answer.title
      end

      it 'edit with invalid' do
        patch "/api/v1/answers/#{answer.id}", params: { answer: { title: '' }, access_token: access_token.token }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'delete' do
      it 'delete question' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }
        expect(Answer.count).to eq 2
      end
    end

    describe 'comments' do
      let(:answer_response) { json['question']['answers'].first }
      let(:comment_response) { answer_response['comments'].first }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API list of' do
        let(:json_response) { comment_response }
        let(:parent_response) { answer_response['comments'] }
        let(:mas) { %w[id comment user_id created_at updated_at] }
        let(:type) { comment }
      end
    end

    describe 'links' do
      let(:answer_response) { json['question']['answers'].first }
      let(:link_response) { answer_response['linkss'].first }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API list of' do
        let(:json_response) { link_response }
        let(:parent_response) { link_response['links'] }
        let(:mas) { %w[id name url created_at updated_at] }
        let(:type) { link }
      end
    end
  end
end
