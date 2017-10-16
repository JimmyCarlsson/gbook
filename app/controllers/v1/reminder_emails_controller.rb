class V1::ReminderEmailsController < ApplicationController
  before_action :authenticate_admin_from_token! 
  before_action :authenticate_admin! 

  def show
    id = params[:id]
    booking = Booking.find_by_id(id)
    if booking.nil?
      jsonapi_render_errors status: 401
    else
      BookingMailer.reminder_email(@model).deliver_now
    end

    render json: {} status: 200
  end
end
