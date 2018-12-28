require 'rails_helper'

RSpec.describe V1::EventsController, type: :controller do
  describe "GET index" do
    context "current user is admin" do
      before(:each) do
        admin = create(:admin)
        past_event = create(:event, :skip_validate, date: DateTime.now - 1.week)
        coming_event = create(:event, date: DateTime.now + 1.week)
        sign_in admin
      end
      context "historical queryparam is set to false" do
        it "all future events are returned" do

          get :index

          expect(response.status).to eq 200
          expect(parsed_json['data'].size).to eq 1
        end
      end
    end
  end
end
