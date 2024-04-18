class Users::DashboardController < ApplicationController
  def show
    user_id = params[:user_id]
    if session[:user_id].present? && session[:user_id].to_i == user_id.to_i
      @user = UserFacade.user_data(user_id)
      @tattoos = UserFacade.dashboard_tattoos(user_id)
      render 'users/dashboard'
    else
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end
end
