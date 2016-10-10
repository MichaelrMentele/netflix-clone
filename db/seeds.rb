# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
categories = Category.create([
  {
    tag: "Comedy"
  },
  {
    tag: "Action"
  }
])

movies = Video.create([
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  },
  {
    title: "Monk",
    description: "Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah Lipsum dor, blah blah blah ",
    small_cover_url: "/tmp/monk.jpg",
    large_cover_url: "/tmp/monk_large.jpg",
    category_id: 1
  }

  ])

kevin = User.create(username: "Kevin Wang", password: "pass", email: "kevin@wang.com")

reviews = Review.create([
  {
    user: kevin, video: movies.first, rating: 3, description: "blah blah"
  },
  {
    user: kevin, video: movies.first, rating: 4, description: "blah blah"
  }

  ])