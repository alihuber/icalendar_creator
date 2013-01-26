# encoding: utf-8

class EventStringCreator
  attr_accessor :event

  def initialize(event)
    @event = event
  end


  def create_all_day_non_us_date
    # Input: 31.12.2012
    # Output: 20121231
    "DTSTART;VALUE=DATE:" + @event.start_date.split(".").reverse!.join + "\n" +
    "DTEND;VALUE=DATE:" + @event.end_date.split(".").reverse!.join + "\n"
  end

  def create_all_day_us_date
    # Input: 12/31/2012
    # Output: 20121231
    start_ary = @event.start_date.split("/")
    end_ary = @event.end_date.split("/")
    "DTSTART;VALUE=DATE:" + start_ary[2] + start_ary[0] + start_ary[1] + "\n" +
    "DTEND;VALUE=DATE:" + end_ary[2] + end_ary[0] + end_ary[1] + "\n"
  end

  def create_non_all_day_non_us_date
    # Input: 31.12.2012 13:00
    # Output: 20121231T130000
    "DTSTART:" + @event.start_date.split(".").reverse!.join +
    "T" + @event.start_time.delete!(":") + "00" +"\n" +
    "DTEND:" + @event.end_date.split(".").reverse!.join +
    "T" + @event.end_time.delete!(":") + "00" + "\n"
  end

  def create_non_all_day_us_date
    # Input: 12/31/2012 13:00
    # Output: 20121231T130000
    start_ary = @event.start_date.split("/")
    end_ary = @event.end_date.split("/")
    "DTSTART:" + start_ary[2] + start_ary[0] + start_ary[1] +
    "T" + @event.start_time.delete!(":") + "00" + "\n" +
    "DTEND:" + end_ary[2] + end_ary[0] + end_ary[1] +
    "T" + @event.end_time.delete!(":") + "00" + "\n"
  end


  def create_event_string
    output = create_event_start_string

    output += create_all_day_non_us_date if @event.is_all_day and not @event.is_us_format
    output += create_non_all_day_non_us_date if not @event.is_all_day and not @event.is_us_format
    output += create_all_day_us_date if @event.is_all_day and @event.is_us_format
    output += create_non_all_day_us_date if not @event.is_all_day and @event.is_us_format

    output += create_event_repetition if @event.is_repeated

    output += create_event_name
    output += create_event_location
    output += create_event_description
    output += create_event_end_string
    output
  end

  def create_event_repetition
    fix_event_repetition
    "RRULE:" + "FREQ=" + @event.repetition_freq + ";" +
    "INTERVAL=" + @event.repetition_interval + "\n"
  end

  def fix_event_repetition
    if @event.is_us_format
      @event.repetition_freq.upcase!
    else
        @event.repetition_freq = "YEARLY" if @event.repetition_freq == "Jährlich"
        @event.repetition_freq = "MONTHLY" if @event.repetition_freq == "Monatlich"
        @event.repetition_freq = "WEEKLY" if @event.repetition_freq == "Wöchentlich"
        @event.repetition_freq = "DAILY" if @event.repetition_freq == "Täglich"
    end
  end

  def create_event_description
    "DESCRIPTION:" + @event.description + "\n"
  end

  def create_event_location
    "LOCATION:" + @event.location + "\n"
  end

  def create_event_name
    "SUMMARY:" + @event.name + "\n"
  end

  def create_event_start_string
    "BEGIN:VEVENT\n"
  end

  def create_event_end_string
    "END:VEVENT\n"
  end

end

class ICalendarCreator

  attr_accessor :events

  def initialize
    @events ||= {}
  end

  def create_icalendar
    output = ""
    output += "BEGIN:VCALENDAR\n"
    output += "VERSION:2.0\n"
    output += "PRODID:-//ICalendarCreator//NONSGML//EN\n"
    @events.each do |num, event|
      output << EventStringCreator.new(event).create_event_string
    end
    output += "END:VCALENDAR\n"
    output
  end

  def add_event(index, event)
    @events[index] = event
  end
end


class Event
  attr_accessor :name, :start_date, :end_date,
    :start_time, :end_time, :location, :description, :is_all_day, :is_us_format,
    :repetition_freq, :repetition_interval, :is_repeated

  # we expect a hash
  def initialize(args)
    @name = args["name"]
    @start_date = args["start_date"]
    @end_date = args["end_date"]
    @location = args["location"]
    @description = args["description"]

    @start_time = args["start_time"] if args.include? "start_time"

    @end_time = args["end_time"] if args.include? "end_time"

    if args.include? "wholeday"
      @is_all_day = true
    else
      @is_all_day = false
    end

    if @start_date.include? "/"
      @is_us_format = true
    else
      @is_us_format = false
    end

    @repetition_freq = args["repetition_freq"] if args["repetition_freq"] != ""

    @is_repeated = true if args["repetition_freq"] != ""

    if args["repetition_interval"] != ""
      @repetition_interval = args["repetition_interval"]
    else
      @repetition_interval = "1"
    end

  end



end
