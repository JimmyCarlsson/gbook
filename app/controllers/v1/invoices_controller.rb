class V1::InvoicesController < ApplicationController

  def show
    id = params[:id]
    booking = Booking.where(token: id).first
    if !booking
      jsonapi_render_errors status: 404
      return
    end

    pdf = InvoicePdf.new(booking)
    send_data pdf.render, filename: "Faktura_#{booking.event.name}_#{booking.event.date.strftime("%Y%m%d")}_#{booking.id}.pdf", type: "application/pdf", disposition: "inline"

  end
end
