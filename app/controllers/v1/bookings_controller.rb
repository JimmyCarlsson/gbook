class V1::BookingsController < V1::BaseController
  before_action :authenticate_admin_from_token! 
  before_action :authenticate_admin! , except: [:create, :show, :show_relationship]

  def show
    token = params[:id]
    booking = Booking.where(token: token).first
    if booking
      jsonapi_render json: booking
    else
      jsonapi_render_errors status: 404
    end

  end

  def index
    # Only show bookings for events that are in the future, or maximum 3 months ago.
    events = Event.where('date > ?', Date.today - 90.days)
    event_ids = events.pluck(:id)
    bookings = Booking.where(event_id: event_ids)

    if params[:paid] == "false"
      bookings = bookings.where(paid: false)
    end

    if params[:sort_by].present?
      bookings = bookings.order(params[:sort_by])
    end

    jsonapi_render json: bookings
  end
end
