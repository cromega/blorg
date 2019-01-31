require "spec_helper"

require "capybara/rspec"
require "capybara/apparition"
require "sinatra/base"
require "pry"
require "fileutils"

Capybara.register_driver :apparition do |app|
  options = {headless: !(ENV["HEADLESS"] == "false")}
  Capybara::Apparition::Driver.new(app, options)
end
Capybara.javascript_driver = :apparition

Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |lib| require lib }

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
