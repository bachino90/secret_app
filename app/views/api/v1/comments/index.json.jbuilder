json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :author_is_friend, :i_am_author, :created_at
  json.url api_v1_user_secret_comment_path(@user, @secret, comment, format: :json)
end
