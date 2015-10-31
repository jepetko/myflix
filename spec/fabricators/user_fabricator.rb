Fabricator(:user) do
  email { Faker::Internet.email }
  password '123'
  password_confirmation '123'
  full_name { Faker::Name.name }
  reset_password_token nil
  stripe_id nil
end