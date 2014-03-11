class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :password, type: String
  field :facebook_id, type: String, default: ""
  field :twitter_id, type: String, default: ""
  field :phone_number, type: String, default: ""
  field :interests, type: Array, default: []
  field :friends, type: Array, default: []

  has_many :secrets, inverse_of: :user
  has_many :notifications, inverse_of: :user, after_add: :send_notification_to_user
  embeds_many :devices, inverse_of: :user

  #validates_uniqueness_of :email
  #index ({user_id: 1}, {unique: true, name: "user_index"})

  def send_notification_to_user(notification)

  end

  #def password=(password)
  #  write_attribute(:password, BCrypt::Password.create(password))
  #end

end
