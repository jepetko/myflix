Fabricator(:payment) do
  user(fabricator: :user)
  amount 999
  reference_id "ch_#{SecureRandom.hex}"
end