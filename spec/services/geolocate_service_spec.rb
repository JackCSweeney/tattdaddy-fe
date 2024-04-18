require 'rails_helper'

RSpec.describe GeolocateService do
  before(:each) do
    @service = GeolocateService

    @json_response_1 = File.read("spec/fixtures/geolocation/geolocate_coords.json")
    @json_response_2 = File.read("spec/fixtures/geolocation/geocode_address.json")
    stub_request(:post, "https://www.googleapis.com/geolocation/v1/geolocate?key=#{Rails.application.credentials.google_maps_api}")
      .to_return(status: 200, body: @json_response_1)
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?key=#{Rails.application.credentials.google_maps_api}&latlng=34.0393984,-118.4038912")
      .to_return(status: 200, body: @json_response_2)
  end

  describe '.class methods' do
    describe '.find_coords' do
      it 'returns the coordinate json data' do
        response = @service.find_coords
        response = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to eq({:accuracy=>946.4414070017323, :location=>{:lat=>34.0393984, :lng=>-118.4038912}})
      end
    end
    
    describe '.find_address(coords)' do
      it 'returns the json data for the address of the input coords' do
        response = @service.find_address("34.0393984,-118.4038912")
        response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to eq({:results => [{:address_components=>[{:long_name=>"2852", :short_name=>"2852", :types=>["street_number"]}, {:long_name=>"Forrester Drive", :short_name=>"Forrester Dr", :types=>["route"]}, {:long_name=>"Monte Mar Vista", :short_name=>"Monte Mar Vista", :types=>["neighborhood", "political"]}, {:long_name=>"Los Angeles", :short_name=>"Los Angeles", :types=>["locality", "political"]}, {:long_name=>"Los Angeles County", :short_name=>"Los Angeles County", :types=>["administrative_area_level_2", "political"]}, {:long_name=>"California", :short_name=>"CA", :types=>["administrative_area_level_1", "political"]}, {:long_name=>"United States", :short_name=>"US", :types=>["country", "political"]}, {:long_name=>"90064", :short_name=>"90064", :types=>["postal_code"]}, {:long_name=>"4662", :short_name=>"4662", :types=>["postal_code_suffix"]}], :formatted_address=>"2852 Forrester Dr, Los Angeles, CA 90064, USA", :geometry=>{:bounds=>{:northeast=>{:lat=>34.0393184, :lng=>-118.4038736}, :southwest=>{:lat=>34.0390691, :lng=>-118.4041014}}, :location=>{:lat=>34.0391732, :lng=>-118.4040331}, :location_type=>"ROOFTOP", :viewport=>{:northeast=>{:lat=>34.0405427302915, :lng=>-118.4026385197085}, :southwest=>{:lat=>34.0378447697085, :lng=>-118.4053364802915}}}, :place_id=>"ChIJJZ8Vt9q7woARrbU1HxYR-gk", :types=>["premise"]}]})
      end
    end
  end
end