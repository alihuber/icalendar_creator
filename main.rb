require 'sinatra'
require 'haml'
require 'tempfile'
require_relative 'ical.rb'

class ICalendarApp < Sinatra::Application
  set :haml, :format => :html5

  # sessions store generated events
  enable :sessions

  configure do
    set :public_folder, Proc.new{ File.join(root, "static") }
  end


  get '/' do
    # the session gets cleared each time
    # the user refreshes/leaves the page
    session.clear
    session[:calendar] = ICalendarCreator.new
    extract_locale_from_accept_language_header
    haml :index
  end


  get '/delete' do
    # the AJAX-Request brings the id of
    # the event to be deleted
    event_id = params.keys.first
    session[:calendar].events.delete(event_id.to_i)
    return
  end


  # a new event is added
  get '/new' do
    extract_locale_from_accept_language_header
    # "event_name"=>"Test3",
    # "start_date"=>"16.12.2012",
    # "start_time"=>"22:24",
    # "end_date"=>"18.12.2012",
    # "end_time"=>"21:24",
    # "location"=>"Loc",
    # "description"=>"Desc"
    # or
    # "event_name"=>"Test2",
    # "start_date"=>"22.12.2012",
    # "end_date"=>"25.12.2012",
    # "wholeday"=>"wholeday",
    # "location"=>"Loc2",
    # "description"=>"Desc2"
    @event = nil
    if params.size == 6
      params.delete("wholeday")
      @event = Event.new(params.values)
    else
      @event = Event.new(params.values)
    end

    # add new Event in this sessions ICalendar
    @id = nil
    if not session[:calendar].events.empty?
      @id = session[:calendar].events.keys.max + 1
      session[:calendar].add_event(@id, @event)
    else
      @id = 1
      session[:calendar].add_event(@id, @event)
    end

    puts session[:calendar].events

    # return html fragment to put variables in
    # and add to site
    haml :event
  end


  get '/generate' do
    file = Tempfile.new('icalendar.ics')
    text = session[:calendar].create_icalendar
    file.write text
    file.close
    send_file file.path, :filename => 'icalendar.ics'
  end

  def extract_locale_from_accept_language_header
    @language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  run! if app_file == $0

end

