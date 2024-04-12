require "rails_helper"

RSpec.describe IdentityFacade do
  describe ".get_all_identities" do
    it "returns list of all identities" do
      json_response = File.read("spec/fixtures/identities_list.json")

      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response)

      identities = IdentityFacade.list_all_identities

      expect(identities).to be_an(Array)
      expect(identities).to all(be_an(Identity))
    end
  end
end