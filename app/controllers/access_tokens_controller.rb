class AccessTokensController < ApplicationController

    
        def create
        authenticator = UserAuthenticator.new(params[:code])    
        begin authenticator.perform       
        # rescue from ApplicationController kicks in here since UserAuthenticator::AuthenticationError in perform
        end                                                                                                                                                                                                            

    end

end