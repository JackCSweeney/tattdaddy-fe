class Users::AppointmentsController < ApplicationController
  def index
    user_id = params[:user_id]
    @user = UserFacade.user_data(user_id)
    # @appointments = UserFacade.appointments(user_id)
    render "users/appointments"
  end
end