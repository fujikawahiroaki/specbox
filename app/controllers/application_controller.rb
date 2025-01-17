class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include RansackMemory::Concern

  before_action :save_and_load_filters

  def require_login
    return if current_user

    redirect_to root_url
  end

  def current_user
    decoded_id_token if session[:credentials]
  end

  def current_username
    session[:userinfo][:sub].sub("|", ".") if session[:userinfo]
  end

  def save_current_user_id
    unless session[:current_user_id]
      if session[:credentials]
        user = AuthUser.find_by username: current_username
        session[:current_user_id] = user.id
      end
    end
  end

  def current_user_id
    save_current_user_id
    session[:current_user_id]
  end

  def decoded_id_token
    JWT.decode(session[:credentials][:id_token], nil, false)[0].deep_symbolize_keys
  end

  def toggle_direction(column)
    if params[:sort] == column && params[:direction] == "asc"
      "desc"
    else
      "asc"
    end
  end
end
