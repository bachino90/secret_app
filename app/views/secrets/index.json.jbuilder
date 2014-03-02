json.array!(@secrets) do |secret|
  json.extract! secret, :id, :content, :media_url, :about
  json.url user_secret_path(@user, secret, format: :json)
end
