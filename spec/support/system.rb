require 'rails_helper'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # driven_by :rack_test
    driven_by ENV['SHOW_BROWSER'] ? :selenium_chrome : :selenium_chrome_headless
  end

  # allow use of dom_id method in tests
  config.include ActionView::RecordIdentifier
end
