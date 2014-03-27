class ApiSessionToken

	def initialize(existing_token=nil, redis=_redis_connection)
		@token = existing_token
		@redis = redis
	end

	def token
		@token ||= hash(new_remember_token) #MicroToken.generate 128
	end

	def user
    #return unless valid?
    @user ||= _retrieve_user
  end

  def user=(user)
    _set_with_expire(_user_id_key, user.id)
    @user = user
  end

	def valid?
		_retrieve_user_id
	end

	def deleted?
    @deleted
  end

  def delete!
    @redis.del(_user_id_key)
    @deleted = true
  end

  def response
    return ApiSessionTokenResponse.new(@token, @user.id) if valid?
  end

	private

		def new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def hash(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	def _set_with_expire(key,val)
    	@redis[key] = val
  	end

  	def _retrieve_user_id
  		@redis[_user_id_key]
  	end

  	def _retrieve_user
    	user_id = _retrieve_user_id
    	User.find(user_id) if user_id
  	end

  	def _user_id_key
    	"session_token/#{token}/user_id"
  	end

  	def _redis_connection
    	opts = {}
    	opts[:driver] = :hiredis
    	Redis.new opts
  	end
end

class ApiSessionTokenResponse
  def initialize(token, user_id)
    @token = token
    @user_id = user_id.to_s
  end
end


