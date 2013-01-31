require 'spec_helper'

describe "properties/show" do

    let(:common_part) {"/properties/show?client_id=dev"}

  describe '/properties/show?client_id=dev&listing_id=538652956' do

    it "Return results as XML "  do
      url =  SERVICE_URL+"/listings/search?client_id=dev"
      resp = HTTParty.get(url)
      resp["returned_rows"].should == 10
      listing_id = resp["listings"][0]["id"]

      url =  SERVICE_URL+common_part+"&listing_id=#{listing_id}"
      resp = HTTParty.get(url)
      resp["property"]["listings"][0]["id"].should == listing_id
    end
  end


end