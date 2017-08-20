class V1::EventsController < V1::BaseController
  before_action :authenticate_admin_from_token! #, except: [:index, :show, :get_related_resource]
  #before_action :authenticate_admin! #, except: [:index, :show, :get_related_resource]
  #
  ## USE THIS LINE WHEN GOING LIVE - WILL MAKE IT POSSIBLE FOR USERS NOT LOGGED IN TO SEE EVENTS AND CREATE BOOKINGS!
  before_action :authenticate_admin! , except: [:index, :show, :get_related_resource]
  def index
    if context[:current_admin].nil?
      events = Event.where("date <= ?", Date.today).order(:date)
    else
      if params[:historical] == "true"
        events = Event.where('date <= ?', Date.today).order(:date)
      else
        events = Event.where("date > ?", Date.today).order(:date)
      end
    end

    jsonapi_render json: events
  end
end
