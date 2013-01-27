require './main.rb'
require 'capybara/dsl'
require 'capybara/rspec'
require 'selenium/webdriver'


Capybara.app = ICalendarApp

Capybara.register_driver :firefox_en do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["intl.accept_languages"] =  "en"
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end



RSpec.configure do |config|
  config.include Capybara
end
