class Device
  include Mongoid::Document
  field :device_id, type: String
  field :remember_token, type: String

  embedded_in :user, inverse_of: :devices

end
