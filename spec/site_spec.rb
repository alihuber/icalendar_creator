# encoding: utf-8

require './main.rb'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

# no fancy setup
Capybara.app = ICalendarApp
Capybara.default_driver = :selenium

# smoke test
describe "visiting index site", :type => :feature do
  it "gets the index page" do
    visit '/'
    page.should have_text("Erstelle eine iCalendar-Datei.")
  end
end


describe "basic event creation", :type => :feature do

  it "displays a created event" do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "12.02.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "12.02.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_text("Test")
    page.should have_text("12.02.2012")
    page.should have_text("11:00")
    page.should have_text("12:00")
    page.should have_text("Loc")
    page.should have_text("Desc")
    # the next test shows also that id creation of first event is correct
    page.should have_button("deleteButton1")
  end
end


describe "repeated event creation", :type => :feature do

  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    page.select("Täglich", :from => "inputRepFreq")
  end

  it "displays a created event with repetition and no interval" do
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Tag")
    page.should have_button("deleteButton1")
  end

  it "displays a created event with repetition and interval" do
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 12 Tage")
    page.should have_button("deleteButton1")
  end
end


describe "mass event creation", :type => :feature do

  it "displays 10 events" do
    visit '/'
    (1..10).each do |i|
      fill_in("inputEventName", :with => "Test#{i}")
      fill_in("inputStartDate", :with => "12.02.2012")
      fill_in("inputStartTime", :with => "11:00")
      fill_in("inputEndDate", :with => "12.02.2012")
      fill_in("inputEndTime", :with => "12:00")
      fill_in("inputLocation", :with => "Loc#{i}")
      fill_in("inputDescription", :with => "Desc#{i}")
      click_button("submitButton")
    end

    (1..10).each do |i|
      page.should have_text("Test#{i}")
      page.should have_text("Loc#{i}")
      page.should have_text("Desc#{i}")
      page.should have_button("deleteButton#{i}")
    end
  end
end

describe "basic event deletion", :type => :feature do
  it "deletes one event" do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "12.02.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "12.02.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Testlocation")
    fill_in("inputDescription", :with => "Testdescription")
    click_button("submitButton")
    click_button("deleteButton1")
    page.should_not have_text("Test")
    page.should_not have_text("12.02.2012")
    page.should_not have_text("11:00")
    page.should_not have_text("12:00")
    page.should_not have_text("Testlocation")
    page.should_not have_text("Testdescription")
  end
end



describe "mass event deletion", :type => :feature do

  it "deletes ten events" do
    visit '/'
    (1..10).each do |i|
      fill_in("inputEventName", :with => "Test#{i}")
      fill_in("inputStartDate", :with => "12.02.2012")
      fill_in("inputStartTime", :with => "11:00")
      fill_in("inputEndDate", :with => "12.02.2012")
      fill_in("inputEndTime", :with => "12:00")
      fill_in("inputLocation", :with => "Loc#{i}")
      fill_in("inputDescription", :with => "Desc#{i}")
      click_button("submitButton")
    end

    (1..10).each do |i|
      click_button("deleteButton#{i}")
    end

    (1..10).each do |i|
      page.should_not have_text("Test#{i}")
      page.should_not have_text("Loc#{i}")
      page.should_not have_text("Desc#{i}")
      page.should_not have_button("deleteButton#{i}")
    end
  end
end


describe "mixed event creation and deletion", :type => :feature do

  it "creates/deletes events and sets IDs properly" do
    visit '/'

    (1..3).each do |i|
      fill_in("inputEventName", :with => "Test#{i}")
      fill_in("inputStartDate", :with => "12.02.2012")
      fill_in("inputStartTime", :with => "11:00")
      fill_in("inputEndDate", :with => "12.02.2012")
      fill_in("inputEndTime", :with => "12:00")
      fill_in("inputLocation", :with => "Loc#{i}")
      fill_in("inputDescription", :with => "Desc#{i}")
      click_button("submitButton")
    end

    click_button("deleteButton1")
    click_button("deleteButton3")

    # now the max ID is 2, next IDs will be 3..5

    (4..6).each do |i|
      fill_in("inputEventName", :with => "Test#{i}")
      fill_in("inputStartDate", :with => "12.02.2012")
      fill_in("inputStartTime", :with => "11:00")
      fill_in("inputEndDate", :with => "12.02.2012")
      fill_in("inputEndTime", :with => "12:00")
      fill_in("inputLocation", :with => "Loc#{i}")
      fill_in("inputDescription", :with => "Desc#{i}")
      click_button("submitButton")
    end

    page.should have_button("deleteButton2")
    page.should have_button("deleteButton3")
    page.should have_button("deleteButton4")
    page.should have_button("deleteButton5")

    click_button("deleteButton2")
    click_button("deleteButton3")
    click_button("deleteButton4")
    click_button("deleteButton5")

    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
    page.should have_text("Test")
    page.should have_text("02.12.2012")
    page.should have_text("11:00")
    page.should have_text("12:00")
    page.should have_text("Loc")
    page.should have_text("Desc")
    page.should have_button("deleteButton1")
  end
end
