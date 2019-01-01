class V1::ItemsController < V1::BaseController
  before_action :authenticate_admin_from_token! 
end
