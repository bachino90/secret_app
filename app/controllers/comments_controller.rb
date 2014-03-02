class CommentsController < ApplicationController
	before_action :load_user_secret
  before_action :set_comment,  only: [:destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    @comments = @secret.comments
  end

  # GET /secrets/new
  def new
    @comment = @secret.comments.new
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @comment = @secret.comments.build(comment_params)
    @comment.user_id = @user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@user, @secret], notice: 'Secret was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to user_secret_comments_path(@user, @secret) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @secret.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end

    def load_user_secret
      @user = User.find(params[:user_id])
      @secret = Secret.find(params[:secret_id])
    end
end
