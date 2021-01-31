class AccessTokensController < ApplicationController

    
    def create
        authenticator = UserAuthenticator.new(params[:code])    
        access_token = authenticator.perform
        # rescue from ApplicationController kicks in here since UserAuthenticator::AuthenticationError in perform
        return render json: access_token, status: 201
    end

    def destroy
        provided_token = request.authorization&.gsub(/\ABearer\s/, '') 
        # filter in Frontend set Bearer Token from Header and if nil return nil with the & assignment
        access_token = AccessToken.find_by(token: provided_token)
        user = access_token&.user
        raise AuthorizationError unless user
        access_token.destroy 
        # default is 204, we are good here
    end

end