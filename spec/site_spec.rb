# encoding: utf-8

require './main.rb'
require 'spec_helper'



# smoke test
describe "visiting index site", :type => :feature, :driver => :firefox_de do
  it "gets the index page" do
    visit '/'
    page.should have_text("Erstelle eine iCalendar-Datei.")
  end
end


describe "basic event creation", :type => :feature, :driver => :firefox_de do

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


describe "basic repeated event creation", :type => :feature, :driver => :firefox_de do

  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    page.select("Tage", :from => "inputRepFreq")
  end

  it "displays a created event with repetition and no interval" do
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Tag")
  end

  it "displays a created event with repetition and interval" do
    fill_in("inputInterval", :with => "12")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 12 Tage")
  end

  it "displays a correct event with repetition and interval 0" do
    fill_in("inputInterval", :with => "0")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Tag")
  end

  it "displays a correct event with repetition and negative interval" do
    fill_in("inputInterval", :with => "-100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Tag")
  end
end

describe "german language of repeated event creation", :type => :feature, :driver => :firefox_de do
  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02.12.2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
  end

  it "shows correct singular for day" do
    page.select("Tage", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Tag")
  end

  it "shows correct singular for week" do
    page.select("Wochen", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jede Woche")
  end

  it "shows correct singular for month" do
    page.select("Monate", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jeden Monat")
  end

  it "shows correct singular for year" do
    page.select("Jahre", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Jedes Jahr")
  end

  it "shows correct day plural for interval 2" do
    page.select("Tage", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 2 Tage")
  end

  it "shows correct day plural for interval 100" do
    page.select("Tage", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 100 Tage")
  end

  it "shows correct week plural for interval 2" do
    page.select("Wochen", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 2 Wochen")
  end

  it "shows correct week plural for interval 100" do
    page.select("Wochen", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 100 Wochen")
  end

  it "shows correct month plural for interval 2" do
    page.select("Monate", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 2 Monate")
  end

  it "shows correct month plural for interval 100" do
    page.select("Monate", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 100 Monate")
  end

  it "shows correct year plural for interval 2" do
    page.select("Jahre", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 2 Jahre")
  end

  it "shows correct year plural for interval 100" do
    page.select("Jahre", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Alle 100 Jahre")
  end
end


# uses profile for english browser language
describe "english language of repeated event creation", :type => :feature, :driver => :firefox_en do
  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02/12/2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02/12/2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
  end

  it "shows correct singular for day" do
    page.select("Days", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every day")
  end

  it "shows correct singular for week" do
    page.select("Weeks", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every week")
  end

  it "shows correct singular for month" do
    page.select("Months", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every month")
  end

  it "shows correct singular for year" do
    page.select("Years", :from => "inputRepFreq")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every year")
  end

  it "shows correct day plural for interval 2" do
    page.select("Days", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 2 days")
  end

  it "shows correct day plural for interval 100" do
    page.select("Days", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 100 days")
  end

  it "shows correct week plural for interval 2" do
    page.select("Weeks", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 2 weeks")
  end

  it "shows correct week plural for interval 100" do
    page.select("Weeks", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 100 weeks")
  end

  it "shows correct month plural for interval 2" do
    page.select("Months", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 2 months")
  end

  it "shows correct month plural for interval 100" do
    page.select("Months", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 100 months")
  end

  it "shows correct year plural for interval 2" do
    page.select("Years", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 2 years")
  end

  it "shows correct year plural for interval 100" do
    page.select("Years", :from => "inputRepFreq")
    fill_in("inputInterval", :with => "100")
    click_button("submitButton")
    page.should have_css("i.icon-repeat")
    page.should have_text("Every 100 years")
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

describe "basic event deletion", :type => :feature, :driver => :firefox_de do
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


describe "mixed event creation and deletion", :type => :feature, :driver => :firefox_de do

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
