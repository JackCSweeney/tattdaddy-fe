class Tattoo
  attr_reader :id,
              :image_url,
              :price,
              :time_estimate,
              :artist_id

  def initialize(attributes)
    @id = attributes[:id]
    @image_url = attributes[:attributes][:image_url]
    @price = attributes[:attributes][:price]
    @time_estimate = attributes[:attributes][:time_estimate]
    @artist_id = attributes[:attributes][:artist_id]
  end
end