class Users::TattoosController < ApplicationController
  def index
    # GET /api/v0/users/:user_id/tattoos
  end

  def create
    UserFacade.create_user_tattoo(user_tattoo_params)
    redirect_to user_dashboard_path(user_id: params[:user_id])
  end

  def destroy
    # DELETE /api/v0/user_tattoos
  end

  private
  def user_tattoo_params
    params.permit(:user_id, :tattoo_id, :type)
  end
end