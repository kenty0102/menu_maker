Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV.fetch('SELENIUM_DRIVER_URL'), capabilities: options)
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }  # Rails 5+ デフォルトサーバー
  config.server_host = "0.0.0.0"
  config.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', 3001)
end
