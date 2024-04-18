class ArtistsController < ApplicationController
  # before_action :require_login, only: [:show, :edit, :update, :destroy]

  def show
    artist_id = params[:id]
    @artist = ArtistFacade.new.find_artist(artist_id)
    @identities = ArtistFacade.new.find_artist_identities(artist_id)
  end

  def new
    @identities = IdentityFacade.list_all_identities
  end

  def create
    artist = ArtistFacade.create_artist(new_artist_params)
    ArtistFacade.create_artist_identities(artist_identities, artist[:data][:id])
    session[:artist_id] = artist[:data][:id]
    redirect_to artist_dashboard_path(artist[:data][:id])
  end
  
  def destroy
    ArtistFacade.new.delete_artist(params[:id])
    redirect_to root_path, alert: "Artist account successfully deleted"
  end
  
  private
  def new_artist_params
    params.permit(:name, :location, :email, :password)
  end

  def artist_identities
    params[:identities]
  end

  def require_login
    artist_id = params[:id]
    unless session[:artist_id].present? && session[:artist_id] == artist_id.to_i
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end
end