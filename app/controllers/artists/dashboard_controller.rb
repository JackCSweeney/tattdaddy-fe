class Artists::DashboardController < ApplicationController
  def show
    artist_id = params[:artist_id]
    if session[:artist_id].present? && session[:artist_id].to_i == artist_id.to_i
      @artist = ArtistFacade.new.find_artist(artist_id)
      @tattoos = ArtistFacade.new.find_artist_tattoos(artist_id)
      render 'artists/dashboard'
    else
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end
end