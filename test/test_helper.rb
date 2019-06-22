ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Capybara config with docker-compose environment vars
require 'minitest/rails/capybara'
Capybara.app_host = "http://#{ENV['TEST_APP_HOST']}:#{ENV['TEST_PORT']}"
Capybara.javascript_driver = :selenium
Capybara.run_server = false

# Configure the Chrome driver capabilities & register
args = ['--no-default-browser-check', '--start-maximized']
chrome_options = { 'chromeOptions' => { 'args' => args } }
caps = Selenium::WebDriver::Remote::Capabilities.chrome(chrome_options)
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
    desired_capabilities: caps
  )
end
