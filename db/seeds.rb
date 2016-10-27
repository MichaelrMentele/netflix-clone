# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

2.times do 
  Fabricate(:category)
end

10.times do 
  Fabricate(:video, small_cover: '/tmp/monk.jpg', large_cover: '/tmp/monk_large.jpg')
end

4.times do 
  Fabricate(:user)
end

kevin = Fabricate(:user, username: "Kevin Wang", password: "pass", email: "kevin@wang.com", admin: true)

100.times do
  Fabricate(:review, user: User.all.sample, video: Video.all.sample)
end