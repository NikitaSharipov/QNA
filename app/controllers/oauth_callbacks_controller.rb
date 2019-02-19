class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    connection('Github')
  end

  def facebook
    connection('Facebook')
  end

  def connection(provider_name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
