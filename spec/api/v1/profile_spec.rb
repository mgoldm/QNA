# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'aplication/json' }
  end
  let!(:users) { create_list(:user, 3) }

  describe 'GET /api/v1/profiles/me' do

    it_behaves_like 'API Authorizable' do
      let(:api_path) {'/api/v1/profiles/me'}
      let(:method){:get}
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      describe 'profiles' do

        before { get "/api/v1/profiles", params: { access_token: access_token.token }, headers: headers
        }
        it 'return all users' do
          expect(response).to be_successful
        end

        it 'return all public fields' do
          %w[id email admin].each do |attr|
            expect(json['users'].first[attr]).to eq users.first.send(attr).as_json
          end
        end
      end

      describe 'me' do
        before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id email admin].each do |attr|
            expect(json['user'][attr]).to eq me.send(attr).as_json
          end
        end

        it 'returns all public fields' do
          %w[password encrypted_password].each do |attr|
            expect(json).to_not have_key(attr)
          end
        end
      end
    end
  end
end
