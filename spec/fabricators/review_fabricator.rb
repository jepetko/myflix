Fabricator(:review) do
  video nil
  content { Faker::Lorem.sentence(3) }
  rating { (1..5).to_a.sample }
end