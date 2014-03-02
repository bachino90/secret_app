class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :content, type: String

  field :author_is_friend, type: Boolean, default: false
  field :i_am_author, type: Boolean, default: false
  
  embedded_in :secret, inverse_of: :comments
end
