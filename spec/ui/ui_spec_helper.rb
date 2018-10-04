require "spec_helper"

require "capybara"
require "capybara/rspec"
require "sinatra/base"
require "pry"
require "fileutils"
require "selenium-webdriver"
require "chromedriver-helper"

Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |lib| require lib }

Capybara.register_driver :firefox_headless do |app|
  capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.javascript_driver = :firefox_headless

class Blog < Sinatra::Base
  set :root, "_site"
  set :static, true
  set :public_folder, settings.root

  get "*" do
    path = params["splat"].first
    File.read("#{settings.root}/#{path}/index.html")
  end
end

Capybara.server = :webrick
Capybara.app = Blog

RSpec.configure do |config|
  config.before :suite do
    TestRunPrepare.new.tap do |prepare|
      prepare.create_test_post
      prepare.build_content
    end

    Blog.run
  end

  config.after :suite do
    TestRunPrepare.clean_up
  end
end
