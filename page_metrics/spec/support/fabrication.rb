Fabrication.configure do |config|
  config.fabricator_path = 'spec/fabricators'
  config.path_prefix = File.expand_path(Rails.root, 'page_metrics')
end