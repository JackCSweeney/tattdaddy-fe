require "rails_helper"

RSpec.describe Tattoo do
  describe "validations" do
    it "is valid with valid attributes" do
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: 50, time_estimate: 2, artist_id: 1 })
      
      expect(tattoo).to be_valid
    end

    it "is invalid without an image_url" do
      tattoo = Tattoo.new(id: 1, attributes: { price: 50, time_estimate: 2, artist_id: 1 })
      
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:image_url]).to include("can't be blank")
    end

    it "is invalid without a price" do
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", time_estimate: 2, artist_id: 1 })
      
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:price]).to include("is not a number")
    end

    it "is invalid without a time_estimate" do
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: 50, artist_id: 1 })
      
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:time_estimate]).to include("is not a number")
    end

    it "is invalid with a negative price" do
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: -50, time_estimate: 2, artist_id: 1 })
      
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:price]).to include("must be greater than or equal to 0")
    end

    it "is invalid with a negative time_estimate" do
      
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: 50, time_estimate: -2, artist_id: 1 })
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:time_estimate]).to include("must be greater than or equal to 0")
    end

    it "is invalid with non-integer price" do
      
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: "abc", time_estimate: 2, artist_id: 1 })
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:price]).to include("is not a number")
    end

    it "is invalid with non-integer time_estimate" do
      
      tattoo = Tattoo.new(id: 1, attributes: { image_url: "image.jpg", price: 50, time_estimate: "abc", artist_id: 1 })
      expect(tattoo).not_to be_valid
      expect(tattoo.errors[:time_estimate]).to include("is not a number")
    end
  end

  it "creates Tattoo object from parsed JSON data" do
    data = {
      id: "1", 
      type: "tattoos", 
      attributes: {
        image_url: "https://gist.github.com/assets/149989113/fee274f7-0fa9-4606-855b-9c286fcb1661", 
        price: 300, 
        time_estimate: 90, 
        artist_id: 5
        }
      }

    tattoo = Tattoo.new(data)

    expect(tattoo).to be_a(Tattoo)
    expect(tattoo.id).to eq("1")
    expect(tattoo.image_url).to eq("https://gist.github.com/assets/149989113/fee274f7-0fa9-4606-855b-9c286fcb1661")
    expect(tattoo.price).to eq(300)
    expect(tattoo.time_estimate).to eq(90)
    expect(tattoo.artist_id).to eq(5)
  end
end

