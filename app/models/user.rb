class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String
  field :facebook_id, type: String, default: ""
  field :twitter_id, type: String, default: ""
  field :phone_number, type: String, default: ""
  field :interests, type: Array, default: []
  field :friends, type: Array, default: []

  has_many :secrets, inverse_of: :user
  has_many :notifications, inverse_of: :user
  embeds_many :devices, inverse_of: :user


  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i 
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  #validates :password, length: { minimum: 1 }

  #index ({user_id: 1}, {unique: true, name: "user_index"})
end
