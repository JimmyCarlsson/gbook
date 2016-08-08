require 'rails_helper'

RSpec.describe Booking, type: :model do

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
    it {should validate_presence_of(:tickets).with_message("Du måste ange antal biljetter")}
    it {should validate_numericality_of(:tickets).with_message("Antal biljetter måste vara större än 0")}
  end

  # Relations
  describe "event" do
    it {should validate_presence_of(:event)}
    it {should belong_to(:event)}
  end

  # Methods
end
