class UserAuthenticator
    class AuthenticationError < StandardError
    end
  
    attr_reader :user
  
    def initialize(code)
        @code = code
    end
  
    def perform
        if token.try(:error).present?
            raise AuthenticationError
        else
            prepare_user
        end
    end

    private
    attr_reader :code

    def prepare_user
        if User.exists?(login: user_data[:login]) 
            user = User.find_by(login: user_data[:login]) 
        else
          User.create(user_data.merge(provider: 'github'))
        end
    end


    def client 
        @client ||= Octokit::Client.new(
            client_id: ENV['GITHUB_CLIENT_ID'],
            client_secret: ENV['GITHUB_CLIENT_SECRET']
          )
        end

    def token
        token = client.exchange_code_for_token(code)
    end

    def user_data
        user_client = Octokit::Client.new(
            access_token: token)
          user_data = user_client.user.to_h.
            slice(:login, :avatar_url, :url, :name)
    end

end