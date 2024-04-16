class ArtistsController < ApplicationController
  def show
    artist_id = params[:id]
    @artist = ArtistFacade.new.find_artist(artist_id)
    @identities = ArtistFacade.new.find_artist_identities(artist_id)
  end

  def destroy
    ArtistFacade.new.delete_artist(params[:id])
    redirect_to root_path, alert: "Artist account successfully deleted"
  end
end