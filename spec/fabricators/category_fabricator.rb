Fabricator(:category) do 
  tag { Faker::Lorem.words(1).join("") }
end