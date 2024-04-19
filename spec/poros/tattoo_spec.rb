require "rails_helper"

RSpec.describe Tattoo do
  it "creates Tattoo object from parsed JSON data" do
    data = {
      id: "1", 
      type: "tattoos", 
      attributes: {
        image_url: "https://gist.github.com/assets/149989113/fee274f7-0fa9-4606-855b-9c286fcb1661", 
        price: 300, 
        time_estimate: 90, 
        artist_id: 5,
        artist: {
          id: 1,
          name: "Hugh Jalligator",
          email: "hugh@jalligator.com",
          password_digest: nil,
          location: "1453 Swamp Ln, Los Angeles, CA 90032",
          created_at: "2024-04-18T23:21:39.436Z",
          updated_at: "2024-04-18T23:21:39.436Z",
          scheduling_link: "www.website.com"
        }
        }
      }

    tattoo = Tattoo.new(data)

    expect(tattoo).to be_a(Tattoo)
    expect(tattoo.id).to eq("1")
    expect(tattoo.image_url).to eq("https://gist.github.com/assets/149989113/fee274f7-0fa9-4606-855b-9c286fcb1661")
    expect(tattoo.price).to eq(300)
    expect(tattoo.time_estimate).to eq(90)
    expect(tattoo.artist_id).to eq(5)
    expect(tattoo.scheduling_link).to eq("www.website.com")
  end
end