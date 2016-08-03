class V1::BaseController < JSONAPI::ResourceController
  include JSONAPI::Utils
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

  private

  def authenticate_admin_from_token!
    admin_email = params[:admin_email].presence
    admin       = admin_email && Admin.find_by_email(admin_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if admin && Devise.secure_compare(admin.authentication_token, params[:user_token])
      sign_in admin, store: false
    end
  end
end
