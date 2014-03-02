class Secret
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :media_url, type: String, default: ""
  field :about, type: String, default: "00"
  field :likes, type: Array, default: []

  field :comments_count, type: Integer, default: 0
  field :friends_comments_count, type: Integer, default: 0
  field :likes_count, type: Integer, default: 0
  field :friends_likes_count, type: Integer, default: 0

  field :author_is_friend, type: Boolean, default: false
  field :i_am_author, type: Boolean, default: false
  field :i_like_it, type:Boolean, default: false

	belongs_to :user, inverse_of: :secrets #index: true
  embeds_many :comments

  def self.secretsIndex(user,about)
    if about && about != '00'
      secrets = Secret.all_in(about: about).desc(:created_at)
    else
      secrets = Secret.all.desc(:created_at)
    end
    secrets.each do |s|
      s.comments_count = s.comments.count
      s.likes_count = s.likes.count
      if user.friends.include?(s.user_id.to_s)
        s.author_is_friend = true
      elsif s.user_id.to_s == user.id.to_s
        s.i_am_author = true
      end
      if s.likes.include?(user.id.to_s)
        s.i_like_it = true
      end
    end
    return secrets
  end

  #index ({about: 1}, {name: "about_index"})
end
