class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: String
  field :password, type: String
  field :email, type: String, default: ""
  field :face_id, type: String, default: ""
  field :cel_id, type: String, default: ""
  field :interests, type: Array, default: []
  field :friends, type: Array, default: []

  has_many :secrets, inverse_of: :user

  validates_uniqueness_of :user_id
  #index ({user_id: 1}, {unique: true, name: "user_index"})
end
