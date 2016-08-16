require 'rails_helper'

RSpec.describe Booking, type: :model do

  subject {build(:booking)}
  # Fields
  describe "booking_type" do
    it {should validate_inclusion_of(:booking_type).in_array(['private', 'business'])}
    it {should validate_presence_of(:booking_type)}
  end

  describe "name" do
    it {should validate_presence_of(:name).with_message('Du måste ange ett namn')}
  end

  describe "contact_person" do
    context "for a business booking" do
      subject {build(:booking, booking_type: 'business')}
      it {should validate_presence_of(:contact_person).with_message('Du måste ange en kontaktperson')}
    end
    context "for a private booking" do
      subject {build(:booking, booking_type: 'private')}
      it {should allow_value(nil).for(:contact_person)}
    end
  end

  describe "email" do
    it {should validate_presence_of(:email).with_message('Du måste ange en giltig e-postadress')}
    it {should_not allow_value("asd.sad").for(:email).with_message('E-post adressen är inte korrekt formaterad')}
    it {should_not allow_value("asd.sad@s").for(:email).with_message('E-post adressen är inte korrekt formaterad')}
    it {should allow_value('a.s@s.ss').for(:email)}
    it {should allow_value('a@s.ss').for(:email)}
  end

  describe "phone_nr" do
    it {should validate_presence_of(:phone_nr).with_message('Du måste ange ett telefonnummer')}
    it {should allow_value("12456789").for(:phone_nr)}
    it {should_not allow_value("123-45678").for(:phone_nr).with_message("Ange telefonnumret med enbart siffror")}
  end

  describe "tickets" do
    subject {build(:booking)}
    it {should validate_presence_of(:tickets).with_message("Du måste ange antal biljetter")}
    it {should validate_numericality_of(:tickets).with_message("Antal biljetter måste vara större än 0")}

    context "when available seats are less than tickets" do
      it "should give an error message" do
        event = build(:event, seats: 10)
        event.bookings << build(:booking, event: event, tickets: 6)

        booking = build(:booking, event: event, tickets: 5)

        expect(booking.valid?).to be false
        expect(booking.errors.messages[:tickets]).to include("Det finns inte tillräckligt många platser kvar.")
      end
    end

    context "when available seats are equal to tickets" do
      it "should not give an error message" do
        event = build(:event, seats: 10)
        event.bookings << build(:booking, event: event, tickets: 6)

        booking = build(:booking, event: event, tickets: 4)

        expect(booking.valid?).to be true
      end
    end
  end

  describe "discount" do
    subject {build(:booking, event: build(:event, price: 100))}

    it {should allow_value(100).for(:discount)}
    it {should_not allow_value(101).for(:discount)}
    it {should_not allow_value(-1).for(:discount)}
    it {should validate_numericality_of(:discount).with_message("Rabatt måste vara ett heltal")}
  end

  # Relations
  describe "event" do
    it {should validate_presence_of(:event)}
    it {should belong_to(:event)}

    context "with discount" do
      it "should set event discount value" do
        booking = build(:booking, event: build(:event), discount: 100)

        expect(booking.event.discount).to eq 100
      end
    end
  end

  # Methods
  describe "ensure_token" do
    context "when no token exists" do
      it "should generate a token" do
        booking = build(:booking, token: nil)

        booking.ensure_token

        expect(booking.token).to_not be nil
      end
    end
    context "with a token already set" do
      it "should keep that token" do
        booking = build(:booking, token: 'abcdefg')

        booking.ensure_token

        expect(booking.token).to eq 'abcdefg'
      end
    end
  end

  describe "generate token" do
    it "should return a string" do
      booking = build(:booking)

      token = booking.generate_token

      expect(token).to be_a String
    end
  end

  describe "is_business" do
    context "For a business type object" do
      it "should return true" do
        booking = build(:booking, booking_type: 'business')

        expect(booking.is_business).to eq true
      end
    end
    context "for a private type object" do
      it "should return false" do
        booking = build(:booking, booking_type: 'private')

        expect(booking.is_business).to eq false
      end
    end
  end

  describe "is_private" do
    context "For a private type object" do
      it "should return true" do
        booking = build(:booking, booking_type: 'private')

        expect(booking.is_private).to eq true
      end
    end
    context "For a business type object" do
      it "should return false" do
        booking = build(:booking, booking_type: 'business')

        expect(booking.is_private).to eq false
      end
    end
  end

  describe "reference" do
    context "for a private type object" do
      it "should return the name" do
        booking = build(:booking, booking_type: 'private', name: 'name', contact_person: 'contact_person')

        expect(booking.reference).to eq 'name'
      end
    end
    context "for a business type object" do
      it "should return the contact person" do
        booking = build(:booking, booking_type: 'business', name: 'name', contact_person: 'contact_person')

        expect(booking.reference).to eq 'contact_person'
      end
    end
  end

  describe "due_date" do
    it "should return a date" do
      booking = build(:booking, created_at: DateTime.now)

      expect(booking.due_date).to be_a DateTime
    end
  end

  describe "total_price" do
    it "should return the total price including tax" do
      event = build(:event, price: 123)
      booking = build(:booking, event: event, tickets: 3)

      expect(booking.total_price).to eq 369
    end
  end

  describe "total_net_price" do
    it "should return the total price excluding tax" do
      event = build(:event, price: 100, tax6: 20, tax12: 20, tax25: 60)
      booking = build(:booking, event: event, tickets: 3)

      expect(booking.total_net_price.round(1)).to eq 254.2 
    end
  end

  describe "total_tax" do
    it "should return the total tax" do
      event = build(:event, price: 100, tax6: 20, tax12: 20, tax25: 60)
      booking = build(:booking, event: event, tickets: 3)

      expect(booking.total_tax.round(1)).to eq 45.8
    end
  end

  describe "destroy" do
    it "should set deleted_at flag and keep object in database" do
      booking = create(:booking)

      booking.destroy

      expect(booking.deleted_at).to_not be nil

      booking2 = Booking.unscoped.find(booking.id)

      expect(booking2).to_not be nil
    end
  end
end
