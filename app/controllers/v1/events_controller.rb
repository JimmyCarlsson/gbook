class V1::EventsController < V1::BaseController
  before_action :authenticate_admin_from_token! #, except: [:index, :show, :get_related_resource]
  before_action :authenticate_admin! #, except: [:index, :show, :get_related_resource]
  #
  ## USE THIS LINE WHEN GOING LIVE - WILL MAKE IT POSSIBLE FOR USERS NOT LOGGED IN TO SEE EVENTS AND CREATE BOOKINGS!
  #before_action :authenticate_admin! , except: [:index, :show, :get_related_resource]
  def index
    jsonapi_render json: Event.all.order(:date)
  end
end
