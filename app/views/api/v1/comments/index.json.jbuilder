json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :author_is_friend, :i_am_author, :created_at
end
