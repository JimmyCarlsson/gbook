class BookingMailer < ApplicationMailer
 
  def booking_email(booking)
    @booking = booking
    subject_prefix = Rails.env.production? ? "" : "TEST - "
    mail(
      from: "Grebbans <noreply@grebbans.se>", 
      to: [@booking.email, "bookings@grebbans.se"], 
      subject: subject_prefix + "Bokningsbekräftelse #{@booking.event.name} #{@booking.event.date.strftime('%F')}")
  end
end
