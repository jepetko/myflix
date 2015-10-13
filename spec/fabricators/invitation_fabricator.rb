Fabricator(:invitation) do
  user
  email { Faker::Internet.email }
  full_name { Faker::Name.name }
  token { SecureRandom.urlsafe_base64 }
  message { Faker::Lorem.sentence(1) }
end