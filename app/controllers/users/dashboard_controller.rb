class Users::DashboardController < ApplicationController
  def show
    user_id = params[:user_id]
    @user = UserFacade.user_data(user_id)
    @tattoos = UserFacade.dashboard_tattoos(user_id)
    render 'users/dashboard'
  end
end