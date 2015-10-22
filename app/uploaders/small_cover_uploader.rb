class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include UniqueNameGenerator
  process :resize_to_fill => [166, 236]
end
