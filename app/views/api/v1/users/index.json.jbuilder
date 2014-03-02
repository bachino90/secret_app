json.array!(@users) do |user|
  json.extract! user, :id, :user_id, :password
  json.url api_v1_user_path(user, format: :json)
end
