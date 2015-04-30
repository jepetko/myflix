Fabricator(:review) do
  comment Faker::Lorem.sentence(3)
  rating 3
end