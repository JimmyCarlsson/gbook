class SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    super do |admin|
      if request.format.json?
        data = {
          token: admin.authentication_token,
          email: admin.email
        }
        render json: data, status: 201 and return
      end
    end
  end
end
