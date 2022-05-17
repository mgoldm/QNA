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
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    describe 'Post' do
      it 'should create new' do

        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), access_token: access_token.token }

        expect(Answer.count).to eq 1
      end

      it 'ivalid create' do

        post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer, correct: ''), access_token: access_token.token }

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
        expect(Answer.count).to eq 0
      end
    end

    describe 'comments' do
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 3,commentable: answer, user: user) }
      let(:answer_response) { json['question']['answers'].first }
      let(:comment_response){answer_response['comments']}

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns list of answers' do
        comments
        expect(comment_response.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id comment user_id  user_id created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end
end
