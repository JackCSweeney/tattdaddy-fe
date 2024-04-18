require 'rails_helper'

RSpec.describe GeolocateFacade do
  before(:each) do
    @facade = GeolocateFacade

    @json_response_1 = File.read("spec/fixtures/geolocation/geolocate_coords.json")
    @json_response_2 = File.read("spec/fixtures/geolocation/geocode_address.json")
    stub_request(:post, "https://www.googleapis.com/geolocation/v1/geolocate?key=#{Rails.application.credentials.google_maps_api}")
      .to_return(status: 200, body: @json_response_1)
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?key=#{Rails.application.credentials.google_maps_api}&latlng=34.0393984,-118.4038912")
      .to_return(status: 200, body: @json_response_2)
  end

  describe '.class methods' do
    describe '.find_coords' do
      it 'returns the parsed coordinates for the geolocated address' do
        expect(@facade.find_coords).to eq("34.0393984,-118.4038912")
      end
    end

    describe '.parse_coords(response)' do
      it 'parses the response given' do
        response = GeolocateService.find_coords
        expect(@facade.parse_coords(response)).to eq("34.0393984,-118.4038912")
      end
    end

    describe '.find_address(coords)' do
      it 'returns the full address of the parsed coordinates' do
        expect(@facade.find_address("34.0393984,-118.4038912")).to eq("2852 Forrester Dr, Los Angeles, CA 90064, USA")
      end
    end

    describe '.parse_address(response)' do
      it 'parses the data from the response given' do
        response = GeolocateService.find_address("34.0393984,-118.4038912")
        expect(@facade.parse_address(response)).to eq("2852 Forrester Dr, Los Angeles, CA 90064, USA")
      end
    end
  end
end