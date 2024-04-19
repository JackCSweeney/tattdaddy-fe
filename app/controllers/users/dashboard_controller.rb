class Users::DashboardController < ApplicationController
  include ApplicationHelper
  
  def show
    user_id = params[:user_id]
    if session[:user_id].present? && session[:user_id].to_i == user_id.to_i
      @user = UserFacade.user_data(user_id)
      @tattoos = Rails.cache.fetch("#{cache_key_with_version(@user)}-dashboard-tattoos", expires_in: 1.minutes) do
        UserFacade.dashboard_tattoos(user_id)
      end
      render 'users/dashboard'
    else
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end
end
