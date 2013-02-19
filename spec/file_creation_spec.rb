# encoding: utf-8

require './main.rb'
require 'spec_helper'



shared_context "filled in single event" do
  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "12/02/2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "12/02/2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
  end
  after(:each) { DownloadHelper::clear_downloads }
end


describe "creation of a file with one event", :type => :feature, :driver => :chrome do
  include_context "filled in single event"

  it "returns a file with created event" do
    click_button("submitButton")
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end

end



#  Does not work with closing of tabs, since that does not clear the session
describe "beahviour of sessions and created files", :type => :feature, :driver => :chrome do
  include_context "filled in single event"

  it "creates a new session on new visit" do
    click_button("submitButton")
    visit 'http://www.google.com'
    visit '/'

    # generate another event, the first should not be in the file
    fill_in("inputEventName", :with => "Test2")
    fill_in("inputStartDate", :with => "02.12.2013")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02.12.2013")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")

    click_button("generateButton")

    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20131202T110000\nDTEND:20131202T120000\nSUMMARY:Test2\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"

    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end
end


describe "correct file creation with not mandatory forms filled out", :type => :feature, :driver => :chrome do
  include_context "filled in single event"

  it "file is correct with only repetition interval filled out" do
    fill_in("inputInterval", :with => "2")
    click_button("submitButton")

    click_button("generateButton")

    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"

    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end

  it "file is correct with only alarm value filled out" do
    fill_in("inputAlarmTimeValue", :with => "2")
    click_button("submitButton")

    click_button("generateButton")

    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"

    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end
end


describe "correct file creation with repetition forms filled out", :type => :feature, :driver => :chrome do
  include_context "filled in single event"

  it "file is correct with repetition fields filled out" do
    fill_in("inputInterval", :with => "2")
    page.select("Days", :from => "inputRepFreq")
    click_button("submitButton")
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nRRULE:FREQ=DAILY;INTERVAL=2\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end

  it "file is correct with alarm fields filled out" do
    fill_in("inputAlarmTimeValue", :with => "2")
    page.select("Hours", :from => "inputAlarmTimeUnit")
    click_button("submitButton")
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nBEGIN:VALARM\nTRIGGER:-PT2H\nACTION:DISPLAY\nDESCRIPTION:Test\nEND:VALARM\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end

  it "file is correct with everything filled out" do
    fill_in("inputInterval", :with => "2")
    page.select("Days", :from => "inputRepFreq")
    fill_in("inputAlarmTimeValue", :with => "2")
    page.select("Hours", :from => "inputAlarmTimeUnit")
    click_button("submitButton")
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nRRULE:FREQ=DAILY;INTERVAL=2\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nBEGIN:VALARM\nTRIGGER:-PT2H\nACTION:DISPLAY\nDESCRIPTION:Test\nEND:VALARM\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end
end
