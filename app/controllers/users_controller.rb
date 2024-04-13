class UsersController < ApplicationController
  def show
    user_id = params[:id]
    @user = UserFacade.user_data(user_id)
    @user_identities = UserFacade.identity_preferences(user_id)
  end

  def edit
    @user_id = params[:id]
    @user = UserFacade.user_data(@user_id)
    @user_identities = UserFacade.identity_preferences(@user_id)
    @identities = IdentityFacade.list_all_identities
  end

  def destroy
    user_id = params[:id]
    UserFacade.delete_user(user_id)
    redirect_to root_path
    flash[:alert] = "User account successfully deleted"
  end
end