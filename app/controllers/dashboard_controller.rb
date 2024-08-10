class DashboardController < ApplicationController
  def index
    @username = current_username
    @user_id = current_user_id
  end
end
