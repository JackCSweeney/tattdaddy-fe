class ArtistsController < ApplicationController

  def new
    @identities = IdentityFacade.list_all_identities
  end

  def create
    artist = ArtistFacade.create_artist(new_artist_params)
    ArtistFacade.create_artist_identities(artist_identities, artist[:data][:id])
    redirect_to artist_dashboard_path(artist[:data][:id])
  end

  private
  def new_artist_params
    params.permit(:name, :location, :email, :password)
  end

  def artist_identities
    params[:identities]
  end

end