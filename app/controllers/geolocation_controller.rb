class GeolocationController < ApplicationController
  def geolocate
    coords = GeolocateFacade.find_coords
    address = GeolocateFacade.find_address(coords)
    UserFacade.update_user_data(params[:id], {location: address})
    redirect_to user_dashboard_path(params[:id])
  end
end