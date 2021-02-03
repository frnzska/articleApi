class AccessTokensController < ApplicationController
  before_action :authorize!, only: [:destroy]

  def create
    authenticator = UserAuthenticator.new(params[:code])
    access_token = authenticator.perform
    # rescue from ApplicationController kicks in here since UserAuthenticator::AuthenticationError in perform
    render json: access_token, status: 201
  end

  def destroy
    @current_user.access_token.destroy
    # default is 204, we are good here
  end
end
