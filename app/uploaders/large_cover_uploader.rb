class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include UniqueNameGenerator

  process :resize_to_fill => [665, 375]

end
