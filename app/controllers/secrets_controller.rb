class SecretsController < ApplicationController
  before_action :load_user
  before_action :set_secret,  only: [:show, :edit, :update, :destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    if params[:about]
      @secrets = Secret.all_in(about: params[:about])
    else
      @secrets = Secret.all
    end
  end

  # GET /secrets/friends
  def friends
    if params[:about]
      @secrets = Secret.all_in(user_id: @user.friends, about: params[:about])
    else
      @secrets = Secret.all_in(user_id: @user.friends)
    end
    render action: 'index'
  end

  # GET /secrets/1
  # GET /secrets/1.json
  def show
  end

  # GET /secrets/new
  def new
    @secret = @user.secrets.new
  end

  # GET /secrets/1/edit
  def edit
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @secret = @user.secrets.build(secret_params)#Secret.new(secret_params)

    respond_to do |format|
      if @secret.save
        format.html { redirect_to [@user, @secret], notice: 'Secret was successfully created.' }
        format.json { render action: 'show', status: :created, location: @secret }
      else
        format.html { render action: 'new' }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secrets/1
  # PATCH/PUT /secrets/1.json
  def update
    respond_to do |format|
      if @secret.update_attributes(secret_params)
        format.html { redirect_to [@user, @secret], notice: 'Secret was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy
    @secret.destroy
    respond_to do |format|
      format.html { redirect_to user_secrets_path(@user) }
      format.json { head :no_content }
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
