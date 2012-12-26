require_relative '../ical.rb'


describe Event do

  let(:event) { Event.new(['Test', '23.02.2012',
                          '11:00', '24.02.2012',
                          '12:00', 'Loc', 'Desc']) }

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

end


describe "normal event creation" do
  let(:event) { Event.new(['Test', '23.02.2012',
                          '11:00', '24.02.2012',
                          '12:00', 'Loc', 'Desc']) }

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
  let(:event2) { Event.new(['Test2', '23.02.2012',
                          '24.02.2012',
                          'Loc2', 'Desc2']) }

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
  let(:event3) { Event.new(['Test3', '02/23/2012',
                          '02/23/2012',
                          'Loc3', 'Desc3']) }

  it "should be us format" do
    event3.is_us_format.should be true
  end
end
