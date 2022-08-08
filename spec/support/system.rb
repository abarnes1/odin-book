RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
    # driven_by ENV['SHOW_BROWSER'] ? :selenium_chrome : :selenium_chrome_headless
  end
end