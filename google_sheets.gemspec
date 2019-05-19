Gem::Specification.new do |s|
  s.name        = 'google_sheets'
  s.version     = '0.0.8'
  s.date        = '2018-07-03'
  s.summary     = "Basic Google Sheets interaction, using the v4 api."
  s.description = "CRUD Google Sheets in Ruby"
  s.authors     = ["Kyle Murphy"]
  s.email       = 'kmurph73@gmail.com'
  s.files       = ['README.md'] + Dir['lib/**/*']
  s.homepage    = 'http://rubygems.org/gems/google_sheets'
  s.license     = 'MIT'

  s.add_dependency('google-api-client', ['>= 0.11.0', '< 0.22.0'])
  s.add_development_dependency('rspec')
end
