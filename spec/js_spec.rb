# encoding: utf-8

require './main.rb'
require 'spec_helper'

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



describe "javascript behaviour with more forms filled out", :type => :feature, :driver => :firefox_en do
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
    page.select("Daily", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end


describe "javascript behaviour with unneccesary forms filled out", :type => :feature, :driver => :firefox_en do
  before(:each) do
    visit '/'
  end

  it "does not continue with only first repetition-form filled out" do
    page.select("Daily", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end

  it "does not continue with only second repetition-form filled out" do
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 5)
  end
end



describe "javascript behavior with later deactivated forms", :type => :feature, :driver => :firefox_en do
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
    page.select("Daily", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "12")
    # should accept
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end




describe "javascript behavior with impossible german dates", :type => :feature, :driver => :firefox_de do
  before(:each) do
    visit '/'
  end

  it "sets errors in conjunction with no time given correctly" do
    fill_in("inputEventName", :with => "Test")
    # wrong dates, but 2 errors
    fill_in("inputStartDate", :with => "15.12.2012")
    fill_in("inputEndDate", :with => "01.12.2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 2)
    # given start time, still 1 error
    fill_in("inputStartTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    # given start and end time, still 1 error
    fill_in("inputEndTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndDate", :with => "15.12.2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end

  it "sets errors in conjunction with all-day given correctly" do
    fill_in("inputEventName", :with => "Test")
    # wrong date, 1 error
    fill_in("inputStartDate", :with => "15.12.2012")
    fill_in("inputEndDate", :with => "01.12.2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    # set all day, still one error
    find(:css, "input#wholeDayCheckbox[value='wholeday']").set(true)
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndDate", :with => "15.12.2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end


describe "javascript behavior with impossible english dates", :type => :feature, :driver => :firefox_en do
  before(:each) do
    visit '/'
  end

  it "sets errors in conjunction with no time given correctly" do
    fill_in("inputEventName", :with => "Test")
    # wrong dates, but 2 errors
    fill_in("inputStartDate", :with => "02/14/2012")
    fill_in("inputEndDate", :with => "02/01/2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 2)
    # given start time, still 1 error
    fill_in("inputStartTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    # given start and end time, still 1 error
    fill_in("inputEndTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndDate", :with => "02/14/2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end

  it "sets errors in conjunction with all-day given correctly" do
    fill_in("inputEventName", :with => "Test")
    # wrong dates, but 1 error
    fill_in("inputStartDate", :with => "02/14/2012")
    fill_in("inputEndDate", :with => "02/01/2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndTime", :with => "11:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    # set all day, still 1 error
    find(:css, "input#wholeDayCheckbox[value='wholeday']").set(true)
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndDate", :with => "02/14/2012")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end



describe "javascript behavior with impossible german dates/times", :type => :feature, :driver => :firefox_de do
  it "sets errors right with impossible times on one day" do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    fill_in("inputStartTime", :with => "12:00")
    fill_in("inputEndTime", :with => "10:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndTime", :with => "12:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end



describe "javascript behavior with impossible english dates/times", :type => :feature, :driver => :firefox_en do
  it "sets errors right with impossible times on one day" do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02/12/2012")
    fill_in("inputEndDate", :with => "02/12/2012")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    fill_in("inputStartTime", :with => "12:00")
    fill_in("inputEndTime", :with => "10:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 1)
    fill_in("inputEndTime", :with => "12:00")
    click_button("submitButton")
    page.should have_css("div.control-group.error", :count => 0)
  end
end
