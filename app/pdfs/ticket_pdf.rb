require 'prawn'
require 'prawn/table'
class TicketPdf < Prawn::Document

  def initialize(booking)
    super(margin: [0,0,0,0])
    background
    logopath = "#{Rails.root}/app/assets/images/grebbans.png"
    image logopath, at: [255,720],height: 50
    @booking = booking
    move_down 50
    font "Times-Italic"
    text "Välkommen till en oförglömlig kväll", size: 20, align: :center
    move_down 10
    #text "Grebbans Nöjesrestaurang", align: :center
    move_down 50
    font "Helvetica-Bold"
    text @booking.event.name, align: :center
    move_down 10
    font "Times-Roman"
    text "Det här är din biljett - visas upp i entrén", align: :center
    text "Detta dokument gäller som biljett för evenemanget", align: :center
    text "antalet som anges på denna biljett är bindande", align: :center, size: 9
    move_down 20
    text "<b>Antal:</b> #{@booking.tickets}", align: :center, inline_format: true
    move_down 20
    text "<b>Datum:</b> #{@booking.event.date.strftime("%F")}", align: :center, inline_format: true
    text "<b>Insläpp:</b> #{(@booking.event.date - 30.minutes).strftime("%H:%M")} - #{@booking.event.date.strftime("%H:%M")} ", align: :center, inline_format: true
    text "<b>Namn:</b> #{@booking.name}", align: :center, inline_format: true
    move_down 30
    text "<b>Pris:</b> #{@booking.price_actual}:- /pers. #{if @booking.discount.present? && @booking.discount.positive? then "(ord. pris #{@booking.event.price}:- /pers)" end}", align: :center, inline_format: true
    #text "i priset ingår Show, trerätters meny och kaffe.", align: :center, size: 9
    text "Betalning sker mot faktura", align: :center, size: 9
    move_down 20
    text "Dryck tillkommer och köpes i baren.", align: :center
    move_down 10
    text "Har du förköpt dryck kommer mousserande att finnas vid ert bord när ni anländer.", align: :center
    text "Ni blir också tilldelade dryckesbiljetter för resterande del av paket som sedan inbytes i baren.", align: :center
    move_down 20
    font_size 9
    font "Helvetica"
    text "<b>Bra att veta!</b>", align: :center, inline_format: true
    text "<b>Tider: </b>Dörrarna öppnas kl.#{(@booking.event.date - 30.minutes).strftime("%H:%M")} och insläpp sker mellan #{(@booking.event.date - 30.minutes).strftime("%H:%M")}-#{@booking.event.date.strftime("%H:%M")}", align: :center, inline_format: true
    #text "Mat och show pågår till ca kl 23.00. Därefter håller restaurangen öppet längst till 01:00", align: :center, inline_format: true
    move_down 10
    text "<b>Bokning & Betalningsregler:</b>", align: :center, inline_format: true
    text "Det antal som uppges i detta dokument är bindande. Vid obetald faktura är denna biljett ogiltig. ", align: :center, inline_format: true
    text "Observera att vid utebliven betalning och därmed ogiltig biljett kvarstår fordran som således kommer att krävas in via inkasso.", align: :center, inline_format: true
    text "Distansavtalslagen gäller ej vid köp av evenemangsbiljetter.", align: :center, inline_format: true
    move_down 20
    font_size 12
    text "<b>Regler: </b> 18 års gräns.", align: :center, inline_format: true
    text "Vår toleransnivå på berusning vid ankomst är väldigt låg.", align: :center, inline_format: true
    text "Är gästen märkbart påverkad kommer gästen nekas inträde. I sådant fall är gästen själv skyldig att ombesörja transport från platsen.", align: :center, inline_format: true
    text "Grebbans Nöjesrestaurang är inte skyldig till återbetalning för bokad plats om en märkbart påverkad gäst nekas inträde eller avvisas från lokalen vid stökigt uppträdande.", align: :center, inline_format: true
    text "Det är förbjudet enligt lag att ta med medhavd alkoholhaltig dryck in på restaurangen.", align: :center, inline_format: true
    text "På Grebbans Nöjesrestaurang gäller vårdad klädsel.", align: :center, inline_format: true

    bounding_box [20, 130], width: 200 do
      text "Rockenstierna Nöjesproduktion AB"
      text "Kapellvägen 26"
      text "54492 Hjo"
    end

    bounding_box [250, 130], width: 200 do
      text "www.grebbans.se"
      text "info@grebbans.se"
      text "Tfn. 0730-314407"
    end

  end

  def background
    logopath = "#{Rails.root}/app/assets/images/ticket_bg2.png"
    image logopath, at: [0, [841.89]], height: 700
  end

  def format_number(number)
    return ('%.2f' % number).gsub('.', ',')
  end

end
