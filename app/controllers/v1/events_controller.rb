class V1::EventsController < V1::BaseController
  before_action :authenticate_admin_from_token!, except: [:index]
  before_action :authenticate_admin!, except: [:index]
  def index
    jsonapi_render json: Event.all
  end
end
