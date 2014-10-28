puts "Making users"
puts "Making posts"
User.delete_all
Post.delete_all
10.times do |n|
  user = User.create!(email: "user-#{n}@example.com", username: "Username_#{n}",
    password: 'password', password_confirmation: 'password', address: "Street 1#{n}")
  5.times do |nn|
    post = user.posts.create!(title: "Title #{nn}", context: 'lorem ipsum dolor ales')
  end
end
puts "Some Users made"
puts "Some Posts made"