class V1::ItemsController < V1::BaseController
  before_action :authenticate_admin_from_token! 
  before_action :authenticate_admin! , except: [:index, :show, :get_related_resource]
end
