require "rails_helper"

RSpec.describe IdentityService do
  describe ".get_all_identities" do
    it "returns all identities' data" do
      json_response = File.read("spec/fixtures/identities_list.json")

      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response)

      identities = IdentityService.get_all_identities

      expect(identities).to be_a(Hash)
      expect(identities[:data]).to be_an(Array)
      expect(identities[:data].size).to eq(7)
      expect(identities[:data]).to all(be_a(Hash))
      expect(identities[:data]).to all(include(type: "identity"))
    end
  end
end