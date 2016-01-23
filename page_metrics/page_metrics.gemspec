$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "page_metrics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "page_metrics"
  s.version     = PageMetrics::VERSION
  s.authors     = ["Katarina Golbang"]
  s.email       = ["golbang.k@gmail.com "]
  s.homepage    = ""
  s.summary     = "mountable engine for logging the page impressions"
  s.description = "mountable engine for logging the page impressions"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.1"
end
