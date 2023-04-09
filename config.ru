# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# Prepends path helpers: example_path becomes /<relative_url_root>/example instead of /example
map ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
  run Rails.application
end

Rails.application.load_server
