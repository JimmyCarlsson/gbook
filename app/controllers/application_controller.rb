class ApplicationController < ActionController::Base
  respond_to :json
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def authenticate_admin_from_token_param!
    Admin.all.each do |admin|
      if admin.authentication_token == params[:token]
        puts "Signing in " + admin.email + "via authenticate_admin_from_token_param"
        sign_in admin, store: false 
      else
        puts "no authentication for " + admin.email + " from authenticate_admin_from_token_param"
      end
    end
  end
end
