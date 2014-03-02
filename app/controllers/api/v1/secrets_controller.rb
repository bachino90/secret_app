class API::V1::SecretsController < ApplicationController
  before_action :load_user
  before_action :set_secret,  only: [:show, :edit, :update, :destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    @secrets = Secret.secretsIndex(@user,params[:about])
  end

  # GET /secrets/friends
  def friends
    if params[:about]
      @secrets = Secret.all_in(user_id: @user.friends, about: params[:about])
    else
      @secrets = Secret.all_in(user_id: @user.friends)
    end
    render json: @secrets
  end

  # GET /secrets/1
  # GET /secrets/1.json
  def show
    @secret.comments_count = @secret.comments.count
    @secret.likes_count = @secret.likes.count
  end

  # GET /secrets/new
  def new
    @secret = @user.secrets.build
  end

  # GET /secrets/1/edit
  def edit
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @secret = @user.secrets.build(secret_params)#Secret.new(secret_params)

      if @secret.save
        render json: @secret, callbacks: "show" 
      else
        render json: @secret.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /secrets/1
  # PATCH/PUT /secrets/1.json
  def update
      if @secret.update_attributes(secret_params)
        head :no_content
      else
        render json: @secret.errors, status: :unprocessable_entity
      end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy
    @secret.destroy
    head :no_content
  end

  #PUT /secrets/1/like
  def like
    @secret = Secret.find(params[:secret_id])
    if !@secret.likes.include?(@user.id.to_s)
      @secret.likes.push(@user.id.to_s)
      @secret.likes_count = @secret.likes.count
      if @secret.save
        head :no_content
      else
        render json: @secret.errors, status: :unprocessable_entity
      end
    end
  end

  #DELETE /secrets/1/like
  def unlike
    @secret = Secret.find(params[:secret_id])
    if @secret.likes.include?(@user.id.to_s)
      @secret.likes.delete(@user.id.to_s)
      @secret.likes_count = @secret.likes.count
      if @secret.save
        head :no_content
      else
        render json: @secret.errors, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_params
      params.require(:secret).permit(:content, :media_url, :about)
    end

    def load_user
      @user = User.find(params[:user_id])
    end
end
