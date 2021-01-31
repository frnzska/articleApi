require 'rails_helper'

def raw_json
    JSON.parse(response.body)
end

RSpec.describe AccessTokensController, type: :controller do
    describe '#create' do
        let(:user_data) do
            {
              login: 'jsmith1',
              url: 'http://example.com',
              avatar_url: 'http://example.com/avatar',
              name: 'John Smith'
            }
        end

        context 'valid token' do 
        # mock successful token
            before do
                allow_any_instance_of(Octokit::Client).to receive(
                  :exchange_code_for_token).and_return('validaccesstoken')
    
                allow_any_instance_of(Octokit::Client).to receive(
                  :user).and_return(user_data)
              end 

                it 'should return 201 for token created' do
                    post :create, params: { code: 'someValidCode'}
                    expect(response).to have_http_status(:created)
                end

                it 'should return something as a token' do
                    post :create, params: { code: 'someValidCode'}
                    user = User.find_by(login: 'jsmith1')
                    token = user.access_token.reload.token
                    expect(raw_json["data"]["attributes"]["token"]).to eq(token) 
                end
            end


        context 'invalid token' do 
            let(:error) {
                double("Sawyer::Resource", error: "bad_verification_code")
              }
        
              # mock Octokit client with a token returning an error
              before do
                allow_any_instance_of(Octokit::Client).to receive(
                  :exchange_code_for_token).and_return(error)
              end
            
            it 'should return 401 when no token created' do
                post :create
                expect(response).to have_http_status(401)
            end

            it 'should return error body' do
                post :create
                expect(raw_json['errors']['title']).to eq('Authentication code is invalid')
                post :create, params: {code: 'invalid'}
                expect(raw_json['errors']['title']).to eq('Authentication code is invalid')
            end
        end
    end

    describe '#destroy' do 

        context 'successful destroy' do 
            let(:user) { create :user }
            let(:access_token) {user.create_access_token}
            before { request.headers['authorization'] = "Bearer #{access_token.token}" }

            it 'should return 204' do
                post :destroy
                expect(response).to have_http_status(204)
            end
        end

        context 'unsuccessful destroy' do 
            
            it 'should return 403 when resource access forbidden due to no header token' do
                post :destroy
                expect(response).to have_http_status(403)
            end

            before { request.headers['authorization'] = "Invalid" }
            it 'should return 403 when invalid token in header' do
                post :destroy
                expect(response).to have_http_status(403)
            end
        end
    end
end