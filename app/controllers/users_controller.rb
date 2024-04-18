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

  def update
    @user_id = params[:id]
    if user_identities_updated? && user_data_updated?
      UserFacade.update_data_and_identities(@user_id, user_params, identity_changes)
    elsif user_identities_updated? && !user_data_updated?
      UserFacade.update_user_identities(@user_id, identity_changes)
    else
      UserFacade.update_user_data(@user_id, user_params)
    end

    redirect_to user_path(id: @user_id), notice: "Profile updated successfully"
  end

  def destroy
    UserFacade.delete_user(params[:id])
    redirect_to root_path, alert: "User account successfully deleted"
  end

  def new
    @identities = IdentityFacade.list_all_identities
  end

  def create
    user = UserFacade.create_new_user(new_user_params.to_h)
    UserFacade.create_user_identities(user_identities, user[:data][:id])
    session[:user_id] = user[:data][:id]
    redirect_to user_dashboard_path(user[:data][:id])
  end

  private
  def user_params
    params.permit(:name, :email, :location, :search_radius)
  end

  def user_data_updated?
    updated = user_params.to_h
    original = JSON.parse(params[:original_user_data])
    updated != original
  end

  def user_identities_updated?
    params.permit(:original_user_identities, :identities, "original_user_identities", "identities")
    @original_identities = params[:original_user_identities].split if params[:original_user_identities]
    @updated_identities = params[:identities]

    @updated_identities != @original_identities
  end

  def identity_changes
    identity_requests = Hash.new
    identity_requests[:post] = @updated_identities - @original_identities
    identity_requests[:delete] = @original_identities - @updated_identities
    identity_requests
  end

  def user_identities
    params[:identities]
  end

  def new_user_params
    params.permit(:name, :email, :password, :search_radius, :location)
  end
end