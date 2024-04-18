class GeolocationController < ApplicationController
  def geolocate
    address = GeolocateFacade.find_address(params[:coords])
    UserFacade.update_user_data(params[:id], {location: address})
    redirect_to user_dashboard_path(params[:id])
  end
end