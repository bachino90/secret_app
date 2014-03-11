class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_like, type: Mongoid::Boolean, default: false
  field :is_comment, type: Mongoid::Boolean, default: false
  field :secret_id, type: String

  belongs_to :user, inverse_of: :notifications
end
