class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

  private

  def authentication_error
    render json: { "errors": {
      'status' => '401',
      'source' => { 'pointer' => '/code' },
      'title' => 'Authentication code is invalid',
      'detail' => 'You must provide valid code in order to exchange it for token.'
    } }, status: 401
  end

  def authorization_error
    render json: { "errors": {
      'status' => '403',
      'source' => { 'pointer' => '/header/authorization' },
      'title' => 'Access forbidden',
      'detail' => 'You are not authorized to access the resource.'
    } }, status: 403
  end

  def unprocessable_entity_error
    render json: { "errors": {
      'status' => '422',
      'source' => { 'pointer' => '/request' },
      'title' => 'Uprocessable Entity',
      'detail' => 'Server is unable to process the contained instructions.'
    } }, status: 422
  end

  def authorize!
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    # filter in Frontend set Bearer Token from Header and if nil return nil with the & assignment
    access_token = AccessToken.find_by(token: provided_token)
    @current_user = access_token&.user
    raise AuthorizationError unless @current_user
  end
end
