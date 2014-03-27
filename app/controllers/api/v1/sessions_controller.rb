class API::V1::SessionsController < API::V1::ApiController
	skip_before_filter :api_session_token_authenticate!, only: [:create]

	def create
		token = ApiSessionToken.new#current_api_session_token
		if params[:session][:email] && params[:device_id]
			@user = User.find_by(email: params[:session][:email].downcase)
			if _provide_valid_password? || _provide_valid_api_key?
				@user.devices.build(device_id: params[:device_id], remember_token: token.token)
				if @user.save!
					token.user = @user 
					render json: token.response
				else
					_error 'Session dont save', 404
				end
			else
				_error 'User or password are incorrect', 404
			end
		else
			_error 'Wrong parameters', 401
		end
	end

	def destroy
		device = current_user.devices.find_by(remember_token: current_api_session_token.token)
		device.destroy
		current_api_session_token.delete!
		render nothing: true, status: 204
	end

	private

		def _provide_valid_password?
			params[:session][:password] && authenticate_with_password!(@user, params[:session][:password])
		end

		def _provide_valid_api_key?
			params[:api_key] && authenticate_with_api_key!(@user, params[:api_key], current_api_session_token.token)
		end

end
