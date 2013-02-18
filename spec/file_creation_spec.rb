# encoding: utf-8

require './main.rb'
require 'spec_helper'



shared_context "created single event" do
  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "12/02/2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "12/02/2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
  end
end


describe "creation of a file with one event", :type => :feature, :driver => :chrome do
  include_context "created single event"
  after(:each) { DownloadHelper::clear_downloads }

  it "returns a file with created event" do
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20121202T110000\nDTEND:20121202T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
  end

end



#  Does not work with closing of tabs, since that does not clear the session
describe "beahviour of sessions and created files", :type => :feature, :driver => :chrome do
  include_context "created single event"
  after(:each) { DownloadHelper::clear_downloads }

  it "creates a new session on new visit" do
    visit 'http://www.google.com'
    visit '/'

    # generate another event, the first should not be in the file
    fill_in("inputEventName", :with => "Test2")
    fill_in("inputStartDate", :with => "12/02/2013")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "12/02/2013")
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
