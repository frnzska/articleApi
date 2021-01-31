class ApplicationController < ActionController::API
    class AuthorizationError < StandardError
    end

    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
    rescue_from AuthorizationError, with: :authorization_error

    private
    def authentication_error
        render json: {"errors":  {
            "status" => "401",
            "source" => { "pointer" => "/code" },
            "title" =>  "Authentication code is invalid",
            "detail" => "You must provide valid code in order to exchange it for token."
          }}, status: 401 
    end

    def authorization_error
        render json: {"errors":  {
            "status" => "403",
            "source" => { "pointer" => "/header/authorization" },
            "title" =>  "Access forbidden",
            "detail" => "You are not authorized to access the resource."
          }}, status: 403
    end


end
