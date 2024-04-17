class AppointmentsController < ApplicationController
  def index
    artist_id = params[:artist_id]
    @artist = ArtistFacade.new.find_artist(artist_id)
    # @appointments = ArtistFacade.new.appointments(artist_id)
  end
end