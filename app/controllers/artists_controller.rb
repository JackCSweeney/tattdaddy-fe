class ArtistsController < ApplicationController
  def show
    artist_id = params[:id]
    @artist = ArtistFacade.new.find_artist(artist_id)
    @identities = ArtistFacade.new.find_artist_identities(artist_id)
  end

  def new
    @identities = IdentityFacade.list_all_identities
  end

  def edit
    @artist_id = params[:id]
    @artist = ArtistFacade.new.find_artist(@artist_id)
    @artist_identities = ArtistFacade.new.find_artist_identities(@artist_id)
    @identities = IdentityFacade.list_all_identities
  end

  def update 
    @artist_id = params[:id]
    if artist_identities_updated? && artist_data_updated?
      ArtistFacade.update_data_and_identities(@artist_id, artist_params, identity_changes)
    elsif artist_identities_updated? && !artist_data_updated?
      ArtistFacade.update_artist_identities(artist_id, identity_changes)
    else
      ArtistFacade.update_artist_data(@artist_id, artist_params)
    end

    redirect_to artist_path(id: @artist_id), notice: "Profile updated successfully"
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

  def artist_params
    params.permit(:name, :email, :location)
  end

  def artist_identities
    params[:identities]
  end

  def artist_data_updated?
    updated = artist_params.to_h
    original = JSON.parse(params[:original_artist_data])

    updated != original
  end

  def artist_identities_updated?
    @original_identities = params[:original_artist_identities].split
    @updated_identities = params[:identities]

    @updated_identities != @original_identities
  end

  def identity_changes
    identity_requests = Hash.new
    identity_requests[:post] = @updated_identities - @original_identities
    identity_requests[:delete] = @original_identities - @updated_identities
    identity_requests
  end

  def destroy
    ArtistFacade.new.delete_artist(params[:id])
    redirect_to root_path, alert: "Artist account successfully deleted"
  end
end