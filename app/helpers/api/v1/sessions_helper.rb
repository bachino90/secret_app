module API::V1::SessionsHelper
	NotAuthorized = Class.new(Exception)

	module_function

	def authenticate_with_password(user, attempt)
		user && user.authenticate(attempt) 
	end

	def authenticate_with_password!(*args)
		authenticate_with_password(*args) #or raise NotAuthorized
	end

	def authenticate_with_api_key(user, key, current_token)
		user && key && current_token && OpenSSL::Digest::SHA256.new("#{user.email}:#{user.api_secret}:#{current_token}") == key
	end

	def authenticate_with_api_key!(*args)
		authenticate_with_api_key(*args) #or raise NotAuthorized	
	end

end

