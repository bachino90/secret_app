json.array!(@users) do |user|
  json.extract! user, :id, :email, :password, :notifications, :devices
end
