RSpec.configure do |config|
  # Allow use of sign_in method
  config.include Devise::Test::IntegrationHelpers
end