class Users::DashboardController < ApplicationController
  include ApplicationHelper
  def show
    user_id = params[:user_id]
    @user = UserFacade.user_data(user_id)
    Rails.cache.fetch("#{cache_key_with_version(@user)}/dashboard_tattoos", expires_in: 10.minutes) do
      @tattoos = UserFacade.dashboard_tattoos(user_id)
    end
    render 'users/dashboard'
  end
end