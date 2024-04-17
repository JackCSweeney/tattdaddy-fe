class TattoosController < ApplicationController
  include ActiveStorage::SetCurrent
  def index
  end

  def new
    @artist = ArtistFacade.new.find_artist(params[:artist_id])
  end

  def create
    blob = ActiveStorage::Blob.create_and_upload!(io: params[:img_file], filename: params[:img_file].original_filename)
    tattoo_attributes = {price: params[:price], time_estimate: params[:time_estimate], artist_id: params[:artist_id], image_url: blob.url}
    require 'pry'; binding.pry
    service = ArtistService.new.send_new_artist_tattoo(tattoo_attributes)

    if service[:status] == 200 
      redirect_to artist_dashboard_path(params[:artist_id])
      flash[:success] = "Tattoo created successfully"
    else
      redirect_to new_artist_tattoo_path(params[:artist_id])
      flash[:error] = "Tattoo could not be uploaded"
    end
  end

  def edit
    @artist = ArtistFacade.new.find_artist(params[:artist_id])
    @tattoo = ArtistFacade.new.find_tattoo(params[:id])
  end

  def update
    tattoo = ArtistFacade.new.find_tattoo(params[:id])
    
    tattoo_attributes = {tattoo: {price: params[:price], time_estimate: params[:time_estimate], artist_id: params[:artist_id], image_url: tattoo.image_url, id: "2"}}
    
    tattoo = ArtistFacade.new.update_tattoo(tattoo_attributes)

    if tattoo
      redirect_to artist_dashboard_path(params[:artist_id])
      flash[:success] = "Tattoo updated successfully"
    else
      redirect_to edit_artist_tattoo_path(params[:artist_id])
      flash[:error] = "Tattoo could not be updated"
    end
  end

  def destroy
    tattoo = ArtistFacade.new.find_tattoo(params[:id])
    ArtistService.new.delete_tattoo(params[:id])
    
    blob = ActiveStorage::Blob.find_by(key: tattoo.image_url)
    blob.purge if blob

    redirect_to artist_dashboard_path(params[:artist_id])
  end
end