class BookingMailer < ApplicationMailer
 
  def booking_email(booking)
    @booking = booking
    attachments["Faktura_#{booking.event.name}_#{booking.event.date.strftime("%Y%m%d")}_#{booking.id}.pdf"] = InvoicePdf.new(booking).render
    attachments["Biljett_#{booking.event.name}_#{booking.event.date.strftime("%Y%m%d")}_#{booking.id}.pdf"] = TicketPdf.new(booking).render
    subject_prefix = Rails.env.production? ? "" : "TEST - "
    mail(
      from: "Grebbans <noreply@grebbans.se>", 
      to: @booking.email,
      bcc: "bookings@grebbans.se",
      subject: subject_prefix + "Bokningsbekräftelse #{@booking.event.name} #{@booking.event.date.strftime('%F')}")
  end
end
