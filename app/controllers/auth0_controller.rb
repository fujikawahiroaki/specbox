class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env["omniauth.auth"]
    session[:credentials] = {}
    session[:credentials][:id_token] = auth_info["credentials"]["id_token"]
    session[:userinfo] = auth_info["extra"]["raw_info"]

    # Auth0のIDでAuthUserを作成
    # カラム名はusernameだが、実際には一意なIDとして機能している
    auth_user_id = current_username
    AuthUser.find_or_create_by(username: auth_user_id)

    save_current_user_id
    # Redirect to the URL you want after successful auth
    redirect_to "/"
  end

  def failure
    @error_msg = request.params["message"]
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG["auth0_client_id"]
    }

    URI::HTTPS.build(host: AUTH0_CONFIG["auth0_domain"], path: "/v2/logout", query: request_params.to_query).to_s
  end
end
