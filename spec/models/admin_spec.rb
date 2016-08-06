require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "ensure_authentication_token" do
    context "when no token is set" do
      it "should generate a token" do
        admin = build(:admin, authentication_token: nil)

        expect(admin.authentication_token).to be nil

        admin.ensure_authentication_token

        expect(admin.authentication_token).to_not be nil
      end
    end
    context "when a token is set" do
      it "should not regenerate a token" do
        admin = build(:admin, authentication_token: "secret_token")

        admin.ensure_authentication_token

        expect(admin.authentication_token).to eq "secret_token"
      end
    end
  end

  describe "generate_authentication_token" do
    it "should generate a unique token" do
      admin = build(:admin)

      expect(admin.send('generate_authentication_token')).to be_a String
    end
  end
end
