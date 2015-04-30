Fabricator(:review) do
  content { Faker::Lorem.sentence(3) }
  rating { (1..5).to_a.sample }
end