class Users::TattoosController < ApplicationController
  def index
    user_id = params[:user_id]
    if session[:user_id].present? && session[:user_id] == user_id.to_i
      @user = UserFacade.user_data(user_id)
      @tattoos = UserFacade.liked_tattoos(user_id)
      render "users/liked_tattoos"
    else
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end

  def create
    UserFacade.create_user_tattoo(user_tattoo_params)
    redirect_to user_dashboard_path(user_id: params[:user_id])
  end

  def destroy
    UserFacade.delete_user_tattoo(params[:user_id], params[:id])
    redirect_to user_tattoos_path(user_id: params[:user_id])
  end

  private
  def user_tattoo_params
    params.permit(:user_id, :tattoo_id, :type)
  end

end