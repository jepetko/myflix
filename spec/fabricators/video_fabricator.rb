Fabricator(:video) do
  title { %w{'Family Guy' 'Futurama' 'Monk' 'Hobbit' 'Lord of rings' 'Matrix'}.sample }
  description { Faker::Lorem.sentence }
end

picture_dummy_proc = Proc.new do
  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fabricators', 'assets', 'picture_dummy.png'), 'image/png')
end
Fabricator(:video_with_covers_provided, from: :video) do
  large_cover picture_dummy_proc
  small_cover picture_dummy_proc
end