class V1::BookingsController < V1::BaseController
  #before_action :authenticate_admin_from_token!, except: [:index]
  #before_action :authenticate_admin!, except: [:index]
  #def index
  #  jsonapi_render json: Event.all
  #end
  def show
    token = params[:id]
    booking = Booking.where(token: token).first
    if booking
      jsonapi_render json: booking
    else
      jsonapi_render_errors status: 404
    end

  end
end
