Fabricator(:queue_item) do
  video
  user
  order_value Fabricate.sequence(:number, 1)
end