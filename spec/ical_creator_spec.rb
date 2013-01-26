# encoding: utf-8
require_relative '../ical.rb'



describe ICalendarCreator do
  let(:icc)  { ICalendarCreator.new }

  it "works with events" do
    icc.respond_to?(:events).should be true
  end

  it "should be able to create icalendar-strings" do
    icc.respond_to?(:create_icalendar).should be true
  end

  it "can add events to itself" do
    icc.respond_to?(:add_event).should be true
  end

end



describe "event adding and id handling" do

  let(:event) { Event.new({"name" => 'Test', "start_date" => '23.02.2012',
                          "start_time" => '11:00', "end_date" => '24.02.2012',
                          "end_time" => '12:00', "location" => 'Loc', "description" => 'Desc', "repetition_freq" => ""}) }
  let(:event2) { Event.new({"name" => 'Test2', "start_date" => '23.02.2012',
                          "start_time" => '11:00', "end_date" => '24.02.2012',
                          "end_time" => '12:00', "location" => 'Loc2', "description" => 'Desc2', "repetition_freq" => ""}) }
  let(:icc) { ICalendarCreator.new }

  it "should store events in its hash" do
    icc.add_event(1, event)
    icc.events[1].should be event
    icc.add_event(2, event2)
    icc.events[2].should be event2
  end
end


describe "icalendar string creation" do
  let(:event) { Event.new({"name" => 'Test', "start_date" => '23.02.2012',
                          "start_time" => '11:00', "end_date" => '24.02.2012',
                          "end_time" => '12:00', "location" => 'Loc', "description" => 'Desc', "repetition_freq" => ""}) }
  let(:event2) { Event.new({"name" => 'Test2', "start_date" => '23.02.2012',
                          "start_time" => '11:00', "end_date" => '24.02.2012',
                          "end_time" => '12:00', "location" => 'Loc2', "description" => 'Desc2', "repetition_freq" => ""}) }
  let(:event3) { Event.new({"name" => 'Test3', "start_date" => '23.02.2012',
                          "start_time" => '11:00', "end_date" => '24.02.2012',
                          "end_time" => '12:00', "location" => 'Loc3', "description" => 'Desc3', "repetition_freq" => "Wöchentlich",
                          "repetition_interval" => ""}) }
  let(:icc) { ICalendarCreator.new }

  test_string = "BEGIN:VCALENDAR\n" + "VERSION:2.0\n" + "PRODID:-//ICalendarCreator//NONSGML//EN\n" +
    "BEGIN:VEVENT\n" + "DTSTART:20120223T110000\n" + "DTEND:20120224T120000\n" + "SUMMARY:Test\n" +
    "LOCATION:Loc\n" + "DESCRIPTION:Desc\n" +"END:VEVENT\n" + "BEGIN:VEVENT\n" + "DTSTART:20120223T110000\n" +
    "DTEND:20120224T120000\n"  + "SUMMARY:Test2\n" + "LOCATION:Loc2\n" + "DESCRIPTION:Desc2\n" + "END:VEVENT\n" +
    "BEGIN:VEVENT\n" + "DTSTART:20120223T110000\n" +
    "DTEND:20120224T120000\n" + "RRULE:FREQ=WEEKLY;INTERVAL=1\n" + "SUMMARY:Test3\n" + "LOCATION:Loc3\n" + "DESCRIPTION:Desc3\n" + "END:VEVENT\n" +
    "END:VCALENDAR\n"

  it "should be creating a correct iCalendar string" do
    icc.add_event(1, event)
    icc.add_event(2, event2)
    icc.add_event(3, event3)
    icc.create_icalendar.should eq test_string
  end

end
