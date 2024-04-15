class TattoosController < ApplicationController
  include ActiveStorage::SetCurrent
  def index
  end

  def new
    @artist_id = params[:artist_id]
  end

  def create
    blob = ActiveStorage::Blob.create_and_upload!(io: params[:img_file], filename: params[:img_file].original_filename)
    tattoo_attributes = {price: params[:price], time_estimate: params[:time_estimate], artist_id: params[:artist_id], image_url: blob.url}
    
    tattoo = Tattoo.new({id: nil, attributes: tattoo_attributes})
    if tattoo.valid?
      ArtistService.new.send_new_artist_tattoo(tattoo_attributes)
      redirect_to artist_dashboard_path(params[:artist_id])
      flash[:success] = "Tattoo created successfully"
    else
      redirect_to new_artist_tattoo_path(params[:artist_id])
      flash[:error] = "Tattoo could not be uploaded"
    end
  end
end