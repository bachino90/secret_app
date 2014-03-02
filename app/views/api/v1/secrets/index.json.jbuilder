json.array!(@secrets) do |secret|
  json.extract! secret, :id, :content, :media_url, :about, :comments_count, :likes_count, :likes, :i_am_author, :author_is_friend, :i_like_it, :created_at, :comments
end
