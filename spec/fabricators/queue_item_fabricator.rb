Fabricator(:queue_item) do
  video
  user
  order_value { sequence(:number) { |i| i+1} }
end