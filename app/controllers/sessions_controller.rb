class SessionsController < Devise::OmniauthCallbacksController
  def create
    sign_in_and_redirect User.find_or_create_from_oauth(auth_hash)
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Can not sign in with that account: #{e.message}"
    redirect_to after_sign_in_path_for(:user)
  end
  alias :github :create # hu?
  alias :twitter :create

  def after_omniauth_failure_path_for(*)
    '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
