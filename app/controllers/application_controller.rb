class ApplicationController < ActionController::API
    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

    private
    def authentication_error
        render json: {"errors":  {
            "status" => "401",
            "source" => { "pointer" => "/code" },
            "title" =>  "Authentication code is invalid",
            "detail" => "You must provide valid code in order to exchange it for token."
          }}, status: 401 
    end

end
