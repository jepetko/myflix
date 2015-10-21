class LinkUploader < CarrierWave::Uploader::Base
  include UniqueNameGenerator
end
