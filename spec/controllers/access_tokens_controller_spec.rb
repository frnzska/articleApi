require 'rails_helper'

def raw_json
    JSON.parse(response.body)
end

RSpec.describe AccessTokensController, type: :controller do
    describe '#create' do

        context 'valid token' do 
            it 'should ' do
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
end