class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |admin|
      data = {
        token: admin.authentication_token,
        email: admin.email
      }
      render json: data, status: 201 and return
    end
  end
end
