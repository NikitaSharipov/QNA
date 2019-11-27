require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { "CONTENT_TYPE" => "application/json",
      "ACCEPT" => 'application/json' }
  end

  describe 'Get api/v1' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    describe  'Get api/v1/profiles/me' do
      context 'authorized' do
        let(:user_response) { json['user'] }

        before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(user_response[attr]).to eq me.send(attr).as_json
          end
        end

        it 'does not return private fields' do
          %w[password encrypted_password].each do |attr|
            expect(json).to_not have_key(attr)
          end
        end
      end
    end

    describe  'Get api/v1/profiles' do
      context 'authorized' do
        let!(:user) { create(:user) }
        let(:users_response) { json['users'] }

        before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it "returns all user's profiles except authorized user " do
          expect(users_response.count).to eq (User.all.count - 1)
        end
      end
    end
  end
end
