json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :title, :context, :restricted
  json.url post_url(post, format: :json)
end
