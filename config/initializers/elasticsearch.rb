Elasticsearch::Model.client = Proc.new do
  if Rails.env.staging? || Rails.env.production?
    Elasticsearch::Client.new url: ENV['SEARCHBOX_URL']
  elsif Rails.env.development?
    Elasticsearch::Client.new log: true
  else
    Elasticsearch::Client.new
  end
end.call