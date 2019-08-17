class V1::EventsController < V1::BaseController
  before_action :authenticate_admin_from_token! #, except: [:index, :show, :get_related_resource]
  ## USE THIS LINE WHEN GOING LIVE - WILL MAKE IT POSSIBLE FOR USERS NOT LOGGED IN TO SEE EVENTS AND CREATE BOOKINGS!
  before_action :authenticate_admin! , except: [:index, :show, :get_related_resource]
  def index
    events = Event.all
    # If current user is not an admin, return all future events
    if context[:current_admin].nil?
      events = events.where(hidden: false).where("date >= ?", Date.today).order(:date)
    else
      # If current user is an admin, return historical events if selected
      if params[:historical] == "true"
        events = events.where('date <= ?', Date.today).order(:date)
      else
        events = events.where("date > ?", Date.today).order(:date)
      end
    end

    # If eventname is given, filter out events that start with the name to enable easy configuration from iFrame
    if params[:eventname]
      events = events.where('name ILIKE ?', "#{params[:eventname]}%")
    end

    jsonapi_render json: events
  end

  def show
    event = Event.find_by_id(params[:id])

    # If event is hidden, only allow admins to see it
    if event.hidden && context[:current_admin].nil?
      render json: {}, status: 401, adapter: :json_api
      return
    end

    jsonapi_render json: event
  end
end
