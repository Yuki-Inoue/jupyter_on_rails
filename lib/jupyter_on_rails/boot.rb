root = ENV.fetch('RAILS_ROOT')
app_file = File.expand_path('config/application.rb', root)
require app_file
Rails.application.require_environment!
