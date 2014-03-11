class CommentModel
  attr_accessor :id
  attr_accessor :avatar_id
  attr_accessor :content
  attr_accessor :created_at
  attr_accessor :likes_count

  attr_accessor :author_is_friend
  attr_accessor :i_am_author
  attr_accessor :i_like_it

  def initialize(comment, user)
    @id = comment.id
    @content = comment.content
    @avatar_id = comment.avatar_id
    @created_at = comment.created_at
    @likes_count = comment.likes_count
    @author_is_friend = false
    @i_am_author = false
    @i_like_it = false
    if user.friends.include?(comment.user_id)
        @author_is_friend = true
    elsif comment.user_id == user.id.to_s
      @i_am_author = true
    end
    if comment.likes.include?(user.id.to_s)
      @i_like_it = true
    end
  end
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :avatar_id, type: String
  field :content, type: String
  field :likes, type: Array, default: []
  field :likes_count, type: Integer, default: 0

  field :author_is_friend, type: Boolean, default: false
  field :i_am_author, type: Boolean, default: false
  
  embedded_in :secret, inverse_of: :comments
end
