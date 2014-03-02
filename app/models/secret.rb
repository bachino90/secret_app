class SecretModel
  attr_accessor :id
  attr_accessor :content
  attr_accessor :media_url
  attr_accessor :about
  attr_accessor :created_at

  attr_accessor :comments_count
  attr_accessor :friends_comments_count
  attr_accessor :likes_count
  attr_accessor :friends_likes_count

  attr_accessor :author_is_friend
  attr_accessor :i_am_author
  attr_accessor :i_like_it

  def initialize(secret, user)
    @id = secret.id
    @content = secret.content
    @media_url = secret.media_url
    @about = secret.about
    @created_at = secret.created_at
    @comments_count = secret.comments.count
    @likes_count = secret.likes_count
    @author_is_friend = false
    @i_am_author = false
    @i_like_it = false
    if user.friends.include?(secret.user_id.to_s)
        @author_is_friend = true
      elsif secret.user_id.to_s == user.id.to_s
        @i_am_author = true
      end
      if secret.likes.include?(user.id.to_s)
        @i_like_it = true
      end
  end
end



class Secret
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :media_url, type: String, default: ""
  field :about, type: String, default: "00"
  field :likes, type: Array, default: []

  #field :comments_count, type: Integer, default: 0
  #field :friends_comments_count, type: Integer, default: 0
  field :likes_count, type: Integer, default: 0
  #field :friends_likes_count, type: Integer, default: 0

  #field :author_is_friend, type: Boolean, default: false
  #field :i_am_author, type: Boolean, default: false
  #field :i_like_it, type:Boolean, default: false

	belongs_to :user, inverse_of: :secrets #index: true
  embeds_many :comments

  #index ({about: 1}, {name: "about_index"})

  def self.secretsIndex(user,about)
    if about && about != '00' && about != ''
      secrets = Secret.all_in(about: about).desc(:created_at)
    else
      secrets = Secret.all.desc(:created_at)
    end
    secretsModel = Array.new(secrets.count)
    secrets.each_with_index do |s, i|
      #s.comments_count = s.comments.count
      #if user.friends.include?(s.user_id.to_s)
      #  s.author_is_friend = true
      #elsif s.user_id.to_s == user.id.to_s
      #  s.i_am_author = true
      #end
      #if s.likes.include?(user.id.to_s)
      #  s.i_like_it = true
      #end
      secretsModel[i] = SecretModel.new(s, user)
    end

    return secretsModel
  end

end
