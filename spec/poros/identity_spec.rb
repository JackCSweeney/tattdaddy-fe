require "rails_helper"

RSpec.describe Identity do
  it "creates Identity object from parsed JSON data" do
    data = {
      id: "5",
      type: "identity",
      attributes: {
        identity_label: "Female"
      }
    }

    identity = Identity.new(data)

    expect(identity).to be_a(Identity)
    expect(identity.id).to eq("5")
    expect(identity.label).to eq("Female")
  end
end
