class V1::EventsController < V1::BaseController
  def index
    jsonapi_render json: Event.all
  end
end
