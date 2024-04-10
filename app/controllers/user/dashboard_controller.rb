class User::DashboardController < ApplicationController
  def show
    @user = UserFacade.user(params[:user_id])
    @tattoos = UserFacade.tattoo_results(params[:user_id])
  end
end
