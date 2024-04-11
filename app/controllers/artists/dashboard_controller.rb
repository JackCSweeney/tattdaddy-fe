class Artists::DashboardController < ApplicationController
  def show
    artist_id = params[:artist_id]
    @artist = ArtistFacade.new.find_artist(artist_id)
    @tattoos = ArtistFacade.new.find_artist_tattoos(artist_id)
    render 'artists/dashboard'
  end
end