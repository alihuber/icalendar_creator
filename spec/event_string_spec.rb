require_relative '../ical.rb'

describe EventStringCreator do

  let(:evc) { EventStringCreator.new(Event.new(["Test", "11.11.2011"])) }
  let(:evc2) { EventStringCreator.new(Event.new(["Test2", "11/11/2011"])) }

  it "works on an event" do
    evc.respond_to?(:event).should be true
  end

  it "should be able to create the start of an event string" do
    evc.respond_to?(:create_event_start_string).should be true
  end

  it "should be able to create the ending of an event string" do
    evc.respond_to?(:create_event_end_string).should be true
  end

  it "should be able to add the event name to the event string" do
    evc.respond_to?(:create_event_name).should be true
  end

  it "should be able to add the event location to the event string" do
    evc.respond_to?(:create_event_location).should be true
  end

  it "should be able to add the event description to the event string" do
    evc.respond_to?(:create_event_description).should be true
  end

  it "should be able to generate all-day non-us date strings" do
    evc.respond_to?(:create_all_day_non_us_date).should be true
  end

  it "should be able to generate non-all-day non-us date strings" do
    evc.respond_to?(:create_non_all_day_non_us_date).should be true
  end

  it "should be able to generate all-day us date strings" do
    evc.respond_to?(:create_all_day_us_date).should be true
  end

  it "should be able to generate non-all-day us date strings" do
    evc.respond_to?(:create_non_all_day_us_date).should be true
  end

  it "should be able to create an event_string" do
    evc.respond_to?(:create_event_string).should be true
  end

end

describe "basic header and footer creation" do

  let(:event) { Event.new(['Test', '23.02.2012',
                          '24.02.2012', '11:00',
                          '12:00', 'Loc', 'Desc']) }
  let(:evc) { EventStringCreator.new(event) }

  it "should be able to create an event header" do
    evc.create_event_start_string.should eq "BEGIN:VEVENT\n"
  end

  it "should be able to create the event name string" do
    evc.create_event_name.should eq "SUMMARY:Test\n"
  end

  it "should be able to create the event location string" do
    evc.create_event_location.should eq "LOCATION:Loc\n"
  end

  it "should be able to create the event description string" do
    evc.create_event_description.should eq "DESCRIPTION:Desc\n"
  end

  it "should be able to create an event ending" do
    evc.create_event_end_string.should eq"END:VEVENT\n"
  end

end

describe "non all day non us date creation" do

  let(:event) { Event.new(['Test', '23.02.2012',
                          '11:00', '24.02.2012',
                          '12:00', 'Loc', 'Desc']) }
  let(:evc) { EventStringCreator.new(event) }

  it "should be able to create a non all day non us date string" do
    evc.create_non_all_day_non_us_date.should eq "DTSTART:20120223T110000\nDTEND:20120224T120000\n"
  end
end

describe "all day non us date creation" do

  let(:event2) { Event.new(['Test2', '23.02.2012',
                          '24.02.2012',
                          'Loc2', 'Desc2']) }
  let(:evc) { EventStringCreator.new(event2) }

  it "should be able to create a non all day non us date string" do
    evc.create_all_day_non_us_date.should eq "DTSTART;VALUE=DATE:20120223\nDTEND;VALUE=DATE:20120224\n"
  end
end

describe "all day us date creation" do

  let(:event3) { Event.new(['Test3', '02/23/2012',
                          '02/24/2012',
                          'Loc3', 'Desc3']) }
  let(:evc) { EventStringCreator.new(event3) }

  it "should be able to create an all day us date string" do
    evc.create_all_day_us_date.should eq "DTSTART;VALUE=DATE:20120223\nDTEND;VALUE=DATE:20120224\n"
  end
end


describe "non all day us date creation" do

  let(:event4) { Event.new(['Test4', '02/23/2012',
                          '11:00', '02/24/2012',
                          '12:00', 'Loc4', 'Desc4']) }
  let(:evc) { EventStringCreator.new(event4) }

  it "should be able to create an non all day us date string" do
    evc.create_non_all_day_us_date.should eq "DTSTART:20120223T110000\nDTEND:20120224T120000\n"
  end
end


describe "complete non-all-day event string creation" do

  let(:event) { Event.new(['Test', '23.02.2012',
                          '11:00', '24.02.2012',
                          '12:00', 'Loc', 'Desc']) }
  let(:evc) { EventStringCreator.new(event) }

  it "should create a complete event string" do
    evc.create_event_string.should eql "BEGIN:VEVENT\nDTSTART:20120223T110000\nDTEND:20120224T120000\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\n"
  end
end


describe "complete all-day event string creation" do

  let(:event) { Event.new(['Test', '23.02.2012',
                          '24.02.2012',
                          'Loc', 'Desc']) }
  let(:evc) { EventStringCreator.new(event) }

  it "should create a complete event string" do
    evc.create_event_string.should eql "BEGIN:VEVENT\nDTSTART;VALUE=DATE:20120223\nDTEND;VALUE=DATE:20120224\nSUMMARY:Test\nLOCATION:Loc\nDESCRIPTION:Desc\nEND:VEVENT\n"
  end
end
