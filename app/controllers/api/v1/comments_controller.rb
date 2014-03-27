class API::V1::CommentsController < API::V1::ApiController
  before_action :correct_user
  before_action :load_secret
  before_action :set_comment,  only: [:destroy]

  # GET /secrets
  # GET /secrets.json
  def index
    @comments = @secret.commentsIndex(current_user)
    #@comments = @secret.comments.asc(:created_at)
    #@comments.each do |comment|
    #  if @user.friends.include?(comment.user_id)
    #    comment.author_is_friend = true
    #  elsif comment.user_id == @user.id
    #    comment.i_am_author = true
    #  end
    #end
  end

  # GET /secrets/new
  def new
    @comment = @secret.comments.new
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @comment = @secret.comments.build(comment_params)
    @comment.user_id = current_user.id.to_s
    if @comment.save
      comment = CommentModel.new(@comment, current_user)
      render json: comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy
    @comment.destroy
    head :no_content
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

    def load_secret
      #@user = User.find(params[:user_id])
      @secret = Secret.find(params[:secret_id])
    end

    def correct_user
      return _not_authorized unless current_user.id.to_s == params[:user_id]
    end
end
