class V1::BaseController < JSONAPI::ResourceController
  require 'pp'
  include JSONAPI::Utils
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

  # Used in resources to determine auth level

  def context
    {current_admin: current_admin}
  end

  private

  def authenticate_admin_from_token!
    pp "authentication"
    authenticate_with_http_token do |token, options|
      admin_email = options[:email].presence
      admin = admin_email && Admin.find_by_email(admin_email)

      if admin && Devise.secure_compare(admin.authentication_token, token)
        sign_in admin, store: false
      end
    end
  end
end
