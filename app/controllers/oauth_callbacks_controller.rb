class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    connection('Github', request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email'))
  end

  def facebook
    if User.where(facebook_name: request_info.try(:[], 'name')).empty?
      redirect_to(new_advanced_registration_path) && return if request_info.try(:[], 'email').blank? && !session[:pre_email]
    end

    email = session[:pre_email] || User.where(facebook_name: request_info.try(:[], 'name')).first&.email

    connection('Facebook', email)
  end

  def connection(provider_name, email)
    @user = User.find_for_oauth(request.env['omniauth.auth'], email)

    if @user&.persisted?
      @user.add_facebook_name(request_info.try(:[], 'email'))
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def request_info
    request.env['omniauth.auth'].try(:[], 'info')
  end
end
