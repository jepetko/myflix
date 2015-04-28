Fabricator(:video) do
  title { %w{'Family Guy' 'Futurama' 'Monk' 'Hobbit' 'Lord of rings' 'Matrix'}.sample }
  description { Faker::Lorem.sentence }
end