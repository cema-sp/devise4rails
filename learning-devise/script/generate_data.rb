puts "Making users"
puts "Making posts"
User.delete_all
Post.delete_all
Collaboration.delete_all
10.times do |n|
  user = User.create!(email: "user-#{n}@example.com", username: "Username_#{n}",
    password: 'password', password_confirmation: 'password', 
    address: "Street 1#{n}", confirmed_at: Time.now)
  5.times do |nn|
    post = user.posts.create!(title: "Title #{nn}", context: 'lorem ipsum dolor ales')
  end
end

20.times do |n|
  Post.offset(rand(Post.count)).first.update_attribute(:restricted, true)
end

20.times do |n|
  Post.offset(rand(Post.count)).first.collaborations.
    create!(user: User.offset(rand(User.count)).first)
end

puts "Some Users made"
puts "Some Posts made"