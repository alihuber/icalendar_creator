require_relative '../ical.rb'


describe Event do
  let(:event) { Event.new({"name" => "Test", "start_date" => "23.02.2012",
                          "start_time" => "11:00",
                          "end_date" => "24.02.2012",
                          "end_time" => "12:00", "location" => "loc",
                          "description" => "desc"}) }

  it 'has a name' do
    event.respond_to?(:name).should be true
  end

  it 'has a start date' do
    event.respond_to?(:start_date).should be true
  end

  it 'has an end date' do
    event.respond_to?(:end_date).should be true
  end

  it 'has a start time' do
    event.respond_to?(:start_time).should be true
  end

  it 'has a end time' do
    event.respond_to?(:end_time).should be true
  end

  it 'has a location' do
    event.respond_to?(:location).should be true
  end

  it 'has a description' do
    event.respond_to?(:description).should be true
  end

  it 'knows wheter it is all day' do
    event.respond_to?(:is_all_day).should be true
  end

  it 'knows wheter it is repeated' do
    event.respond_to?(:repetition_freq).should be true
  end

end


describe "normal event creation" do
  let(:event) { Event.new({"name" => "Test", "start_date" => "23.02.2012",
                          "start_time" => "11:00",
                          "end_date" => "24.02.2012",
                          "end_time" => "12:00", "location" => "Loc",
                          "description" => "Desc"}) }

  its "name should be 'Test'" do
    event.name.should eq "Test"
  end

  its "start date should be '23.02.2012'" do
    event.start_date.should eq "23.02.2012"
  end

  its "end date should be '24.02.2012'" do
    event.end_date.should eq "24.02.2012"
  end

  its "start time should be '11:00'" do
    event.start_time.should eq "11:00"
  end

  its "end time should be '12:00'" do
    event.end_time.should eq "12:00"
  end

  its "location should be 'Loc'" do
    event.location.should eq "Loc"
  end

  its "description should be 'Desc'" do
    event.description.should eq "Desc"
  end

  it "should not be all day" do
    event.is_all_day.should be false
  end

  it "should be non-us format" do
    event.is_us_format.should be false
  end
end



describe "all day event creation" do
  let(:event2) { Event.new({"name" => "Test2", "start_date" => "23.02.2012",
                          "end_date" => "24.02.2012",
                          "location" => "Loc2",
                          "description" => "Desc2",
                          "wholeday" => "wholeday"}) }

  its "name should be 'Test2'" do
    event2.name.should eq "Test2"
  end

  its "start date should be '23.02.2012'" do
    event2.start_date.should eq "23.02.2012"
  end

  its "end date should be '24.02.2012'" do
    event2.end_date.should eq "24.02.2012"
  end

  its "location should be 'Loc2'" do
    event2.location.should eq "Loc2"
  end

  its "description should be 'Desc2'" do
    event2.description.should eq "Desc2"
  end

  it "should be all day" do
    event2.is_all_day.should be true
  end

  it "should be non-us format" do
    event2.is_us_format.should be false
  end
end


describe "us date event creation" do
  let(:event3) { Event.new({"name" => "Test3", "start_date" => "02/23/2012",
                          "end_date" => "02/24/2012",
                          "location" => "Loc3",
                          "description" => "Desc3",
                          "wholeday" => "wholeday", "repetition_freq" => ""}) }

  it "should be us format" do
    event3.is_us_format.should be true
  end
end



describe "standard repeated event creation" do
  let(:event4) { Event.new({"name" => "Test4", "start_date" => "02/23/2012",
                          "end_date" => "02/24/2012",
                          "location" => "Loc4",
                          "description" => "Desc4",
                          "wholeday" => "wholeday",
                          "repetition_freq" => "Weekly",
                          "repetition_interval" => ""}) }

  it "should know it is repeated once a week" do
    event4.repetition_freq.should eql "WEEKLY"
    event4.repetition_interval.should eql "1"
  end
end

describe "interval repeated event creation" do
  let(:event5) { Event.new({"name" => "Test5", "start_date" => "02/23/2012",
                          "end_date" => "02/24/2012",
                          "location" => "Loc5",
                          "description" => "Desc5",
                          "wholeday" => "wholeday",
                          "repetition_freq" => "Daily",
                          "repetition_interval" => "2"}) }

  it "should know it is repeated every other day" do
    event5.repetition_freq.should eql "DAILY"
    event5.repetition_interval.should eql "2"
  end
end



describe "interval repeated event creation with bad strings" do
  let(:event5) { Event.new({"name" => "Test5", "start_date" => "02/23/2012",
                          "end_date" => "02/24/2012",
                          "location" => "Loc5",
                          "description" => "Desc5",
                          "wholeday" => "wholeday",
                          "repetition_freq" => "daily",
                          "repetition_interval" => "asdf"}) }

  it "should be repeated every other day despite false string" do
    event5.repetition_freq.should eql "DAILY"
    event5.repetition_interval.should eql "1"
  end
end
