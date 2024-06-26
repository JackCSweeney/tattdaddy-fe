class ArtistsController < ApplicationController
  before_action :require_login, only: [:show, :destroy, :edit,:update]

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
    # require 'pry'; binding.pry
  end

  def create
    artist = ArtistFacade.create_artist(new_artist_params.to_h)
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
    params.permit(:name, :location, :email, :password, :scheduling_link)
  end

  def artist_params
    params.permit(:name, :email, :location, :scheduling_link, identities: [])
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
    @original_identities = (params[:original_artist_identities]&.split || []).map(&:to_i)
    @updated_identities = params[:identities]&.map(&:to_i)
    
    @updated_identities.present? && @original_identities.present? && @updated_identities != @original_identities
  end

  def identity_changes
    identity_requests = Hash.new
    identity_requests[:post] = @updated_identities - @original_identities
    identity_requests[:delete] = @original_identities - @updated_identities
    identity_requests
  end

  def require_login
    artist_id = params[:id]
    unless session[:artist_id].present? && session[:artist_id].to_i == artist_id.to_i
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end
end