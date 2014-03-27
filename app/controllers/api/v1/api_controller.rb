class API::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :api_session_token_authenticate!

  include API::V1::SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

    def signed_in
      !!current_api_session_token.user
    end

    def current_user
      current_api_session_token.user
    end

    def api_session_token_authenticate!
      return _not_authorized unless _authorization_header && current_api_session_token.valid?
    end

    def current_api_session_token
      return @current_api_session_token ||= ApiSessionToken.new(_authorization_header)
    end

    def _authorization_header
      auth_header = request.authorization #headers['HTTP_AUTHORIZATION']
    end

    def _not_authorized message = "Not Authorized"
      _error message, 401
    end

    def _not_found message = "Not Found"
      _error message, 404
    end

    def _error message, status
      render json: { error: message}, status: status
    end

end
