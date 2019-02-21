class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github

    #    if request.env['omniauth.auth']
    #      if  request.env['omniauth.auth']['info']
    #        email = request.env['omniauth.auth']['info']['email']
    #      end
    #    end

    @user = User.find_for_oauth(request.env['omniauth.auth'], request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email'))

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def facebook
    connection('Facebook')
  end

  def connection(provider_name)
    if User.where(facebook_name: request.env['omniauth.auth'].try(:[], 'info').try(:[], 'name')).length == 0
      if request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email').blank? && !session[:pre_email]
        redirect_to new_advanced_registration_path and return
      end
    end

    email = session[:pre_email] || User.where(facebook_name: request.env['omniauth.auth'].try(:[], 'info').try(:[], 'name')).first&.email

    @user = User.find_for_oauth(request.env['omniauth.auth'], email)

    if @user&.persisted?
      @user.add_facebook_name(request.env['omniauth.auth'].try(:[], 'info').try(:[], 'email'))
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

end
