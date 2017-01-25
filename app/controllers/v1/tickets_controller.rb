class V1::TicketsController < ApplicationController

  def show
    id = params[:id]
    booking = Booking.where(token: id).first
    if !booking
      jsonapi_render_errors status: 404
      return
    end

    pdf = TicketPdf.new(booking)
    send_data pdf.render, filename: "Biljett_#{booking.event.name}_#{booking.event.date.strftime("%Y%m%d")}_#{booking.id}.pdf", type: "application/pdf", disposition: "inline"

  end
end
