class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :rememberable, 
         :trackable

  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def salted_authentication_token
    Digest::SHA256.hexdigest authentication_token + current_sign_in_at.to_s
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Admin.where(authentication_token: token).first
    end
  end
end
