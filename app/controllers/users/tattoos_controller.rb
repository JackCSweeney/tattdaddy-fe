class Users::TattoosController < ApplicationController
  def index
    UserFacade.liked_tattoos(user_id: params[:user_id])
    render "users/liked_tattoos"
  end

  def create
    UserFacade.create_user_tattoo(user_tattoo_params)
    redirect_to user_dashboard_path(user_id: params[:user_id])
  end

  def destroy
    require 'pry'; binding.pry
    UserFacade.delete_user_tattoo(user_tattoo_params)
    redirect_to user_tattoos(user_id: params[:user_id])
  end

  private
  def user_tattoo_params
    params.permit(:user_id, :tattoo_id, :type)
  end
end