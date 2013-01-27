# encoding: utf-8

require './main.rb'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

Capybara.app = ICalendarApp
Capybara.default_driver = :selenium


describe "javascript behaviour with single forms filled out", :type => :feature do
  before(:each) do
    visit '/'
  end

  # forms with errors:
  # name, start_date/time, end_date/time, location, description
  # repetition is optional
  it "does not accept a form with nothing filled out" do
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not accept a form with name only" do
    fill_in("inputEventName", :with => "Test")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 4)
  end

  # missing time or date will give the whole form an error
  it "does not accept a form with start date only" do
    fill_in("inputStartDate", :with => "02.12.2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not accept a form with start time only" do
    fill_in("inputStartTime", :with => "10:10")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not accept a form with end date only" do
    fill_in("inputEndDate", :with => "02.10.2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not accept a form with end time only" do
    fill_in("inputEndTime", :with => "10:10")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not accept a form with location only" do
    fill_in("inputLocation", :with => "Test")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 4)
  end

  it "does not accept a form with description only" do
    fill_in("inputDescription", :with => "Test")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 4)
  end
end



describe "javascript behaviour with more forms filled out", :type => :feature do
  before(:each) do
    visit '/'
  end

  it "does not accept a form with start date and start time filled out" do
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 4)
  end

  it "does not accept a form with end date and end time filled out" do
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 4)
  end

  it "does not accept a form with name and start date/time filled out" do
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 3)
  end

  it "does not accept a form with name and start/end date/time filled out" do
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 2)
  end

  it "does not accept with a form with no description" do
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
  end

  it "does accept a form with all necessary fields" do
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end

  it "does accept a form with all fields" do
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    page.select("Täglich", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end


describe "javascript behaviour with unneccesary forms filled out", :type => :feature do
  before(:each) do
    visit '/'
  end

  it "does not continue with only first repetition-form filled out" do
    page.select("Täglich", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not continue with only second repetition-form filled out" do
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end
end



describe "javascript behavior with later deactivated forms", :type => :feature do
  it "accepts a form with filled out but deactivated time forms" do
    visit '/'
    # fill out everything first
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 2)
    # then fill out the rest
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndTime", :with => "12:00")
    # then activate "all-day" checkbox
    find(:css, "input#wholeDayCheckbox[value='wholeday']").set(true)
    page.select("Täglich", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "12")
    # should accept
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end
