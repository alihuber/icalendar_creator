# encoding: utf-8

require './main.rb'
require 'spec_helper'



shared_context "created single event" do
  before(:each) do
    visit '/'
    fill_in("inputEventName", :with => "Test")
    fill_in("inputStartDate", :with => "02/12/2012")
    fill_in("inputStartTime", :with => "11:00")
    fill_in("inputEndDate", :with => "02/12/2012")
    fill_in("inputEndTime", :with => "12:00")
    fill_in("inputLocation", :with => "Loc")
    fill_in("inputDescription", :with => "Desc")
    click_button("submitButton")
  end
end


describe "creation of a file with one event", :type => :feature, :driver => :chrome do
  include_context "created single event"

  it "returns a file with created event" do
    click_button("generateButton")
    wanted_file_content = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ICalendarCreator//NONSGML//EN\nBEGIN:VEVENT\nDTSTART:20120212T110000\nDTEND:20120212T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\nEND:VCALENDAR\n"
    actual_file_content = DownloadHelper::download_content
    actual_file_content.should == wanted_file_content
    DownloadHelper::clear_downloads
  end

end
