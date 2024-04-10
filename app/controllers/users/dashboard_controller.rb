class User::DashboardController < ApplicationController
  def show
    @user = UserFacade.user_data(params[:user_id])
    @tattoos = UserFacade.dashboard_tattoos(params[:user_id])
  end
end