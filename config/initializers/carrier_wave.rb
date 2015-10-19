CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = Rails.application.secrets.s3_bucket_name
    config.aws_acl    = 'public-read'
    config.aws_credentials = {
        access_key_id:     Rails.application.secrets.aws_access_key_id,
        secret_access_key: Rails.application.secrets.aws_secret_access_key,
        region:            Rails.application.secrets.aws_region
    }
  else
    config.storage    = :file
    config.enable_processing = Rails.env.development?
  end
end