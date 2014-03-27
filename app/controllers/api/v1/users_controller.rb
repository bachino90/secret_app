class API::V1::UsersController < API::V1::ApiController
  skip_before_filter :api_session_token_authenticate!, only: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      token = ApiSessionToken.new#current_api_session_token
      @user.devices.build(device_id: params[:device_id], remember_token: token.token)
      if @user.save!
        token.user = @user 
        render json: token.response
      else
        _error 'Session dont save', 404
      end
    else
      render json: @user.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    head :no_content
  end

  # GET /users/notifications
  def notifications
    render json: current_user.notifications
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def device_params
      params.require(:user).permit(:device_id)
    end
end
