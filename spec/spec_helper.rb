require './main.rb'
require 'capybara/dsl'
require 'capybara/rspec'
require 'selenium/webdriver'
require_relative 'download_helper'

Capybara.app = ICalendarApp
Capybara.default_driver = :selenium

Capybara.register_driver :firefox_en do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["intl.accept_languages"] =  "en"
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end

Capybara.register_driver :firefox_de do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["intl.accept_languages"] =  "de"
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end

Capybara.register_driver :chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile["download.default_directory"] = Dir.pwd + "/tmp/"
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
end



RSpec.configure do |config|
  config.include Capybara::DSL
end
