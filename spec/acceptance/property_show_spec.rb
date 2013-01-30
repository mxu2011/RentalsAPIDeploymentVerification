require 'spec_helper'

describe "properties/show" do

  before do

  end

  describe '/properties/show?client_id=dev&listing_id=538652956' do

    let(:listing_id) {538652956}

    it "Return results as XML "  do
      url =  SERVICE_URL+"/properties/show?client_id=dev&listing_id=#{listing_id}"
      resp = HTTParty.get(url)
      resp["property"]["listings"][0]["id"].should == listing_id
    end
  end


end