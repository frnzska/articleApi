require 'rails_helper'

describe UserAuthenticator do
  describe '#perform' do
    let(:error) do
      double('Sawyer::Resource', error: 'bad_verification_code')
    end

    context 'when code is incorrect' do
      # mock Octokit client with a token returning an error
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token
        ).and_return(error)
      end

      it 'should raise an error' do
        authenticator = described_class.new('sample_code')
        expect { authenticator.perform }.to raise_error(
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
          :exchange_code_for_token
        ).and_return('validaccesstoken')

        allow_any_instance_of(Octokit::Client).to receive(
          :user
        ).and_return(user_data)
      end
      it 'should add new user' do
        authenticator = UserAuthenticator.new('one_time_sample_code')
        expect { authenticator.perform }.to change { User.count }.by(1)
      end

      it 'should use existing user' do
        user = create :user, user_data
        authenticator = UserAuthenticator.new('one_time_sample_code')
        expect { authenticator.perform }.not_to change { User.count }
      end

      it 'should create user access token' do
        user = create :user
        authenticator = UserAuthenticator.new('one_time_sample_code')
        expect { authenticator.perform }.to change { AccessToken.count }.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
