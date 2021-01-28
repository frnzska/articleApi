require 'rails_helper'

describe UserAuthenticator do
  describe '#perform' do
    let(:error) {
        double("Sawyer::Resource", error: "bad_verification_code")
      }

      # mock error return of Octokit
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token).and_return(error)
      end

    context 'when code is incorrect' do

      it 'should raise an error' do
        authenticator = described_class.new('sample_code')
        expect{ authenticator.perform }.to raise_error(
          UserAuthenticator::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'when code is correct' do
        let(:user_data) do
            {
              login: 'jsmith1',
              url: 'http://example.com',
              avatar_url: 'http://example.com/avatar',
              name: 'John Smith'
            }
          end

        # mock successful token
        before do
          allow_any_instance_of(Octokit::Client).to receive(
            :exchange_code_for_token).and_return('validaccesstoken')
  
          allow_any_instance_of(Octokit::Client).to receive(
            :user).and_return(user_data)
        end    
      it 'should be fine' do
        authenticator = UserAuthenticator.new('on_time_sample_code')
        expect{ authenticator.perform }.to change{ User.count}.by(1)
      end

  end



  end
end