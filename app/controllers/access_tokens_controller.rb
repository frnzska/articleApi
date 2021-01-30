class AccessTokensController < ApplicationController

    
        def create
        authenticator = UserAuthenticator.new(params[:code])    
        access_token = authenticator.perform       
        # rescue from ApplicationController kicks in here since UserAuthenticator::AuthenticationError in perform
        return render json: access_token, status: 201
    end

end