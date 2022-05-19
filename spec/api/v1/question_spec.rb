# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'aplication/json' }
  end
  describe 'GET /api/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:user_id) { access_token.resource_owner_id }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user_id: user_id) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(json['questions'].first[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'API list of' do
          let(:json_response) { answer_response }
          let(:parent_response) { question_response['answers'] }
          let(:mas) { %w[id title correct user_id created_at updated_at] }
          let(:type) { answer }
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it_behaves_like 'API list of' do
          let(:json_response) { comment_response }
          let(:parent_response) { question_response['comments'] }
          let(:mas) { %w[id comment user_id user_id created_at updated_at] }
          let(:type) { comment }
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it_behaves_like 'API list of' do
          let(:json_response) { link_response }
          let(:parent_response) { question_response['links'] }
          let(:mas) { %w[id name url created_at updated_at] }
          let(:type) { link }
        end
      end

      describe ' Show' do
        before do
          get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
        end
        it 'show question' do
          expect(response).to be_successful
        end

        it 'show json question' do
          %w[id title body user_id created_at updated_at].each do |attr|
            expect(json['question'][attr]).to eq question.send(attr).as_json
          end
        end
      end

      describe 'POST' do
        it 'create new question' do
          post '/api/v1/questions', params: { question: attributes_for(:question, user_id: user_id), access_token: access_token.token }
          expect(Question.count).to eq 3
        end

        it 'invalid values ' do
          post '/api/v1/questions',
               params: { question: attributes_for(:question, title: '', user_id: user_id), access_token: access_token.token }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      describe 'PATCH' do
        it 'edit question' do
          patch "/api/v1/questions/#{question.id}",
                params: { question: { body: 'Question body' }, access_token: access_token.token }
          question.reload
          expect(json['question']['body']).to eq question.body
        end

        it 'edit with invalid' do
          patch "/api/v1/questions/#{question.id}", params: { question: { body: '' }, access_token: access_token.token }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      describe 'delete' do
        it 'delete question' do
          delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }
          expect(Question.count).to eq 1
        end
      end
    end
  end
end
