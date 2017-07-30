class BookingMailer < ApplicationMailer
 
  def booking_email(booking)
    @booking = booking
    mail(
      from: "Grebbans <noreply@grebbans.se>", 
      to: @booking.email, 
      subject: "Bokningsbekräftelse #{@booking.event.name} #{@booking.event.date.strftime('%F')}")
  end
end
