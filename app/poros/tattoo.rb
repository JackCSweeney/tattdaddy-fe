class Tattoo
  include ActiveModel::Model

  attr_reader :id,
              :image_url,
              :price,
              :time_estimate,
              :artist_id

  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :time_estimate, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :image_url, presence: true
  validates :artist_id, presence: true

  def initialize(attributes)
    @id = attributes[:id]
    @image_url = attributes[:attributes][:image_url]
    @price = attributes[:attributes][:price]
    @time_estimate = attributes[:attributes][:time_estimate]
    @artist_id = attributes[:attributes][:artist_id]
  end
end