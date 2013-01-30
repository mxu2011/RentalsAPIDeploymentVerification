require 'spec_helper'

describe "properties/search" do

  before do

  end

  describe '/properties/search?client_id=dev&response_type=xml' do

    it "Return results as XML "  do
      url =  SERVICE_URL+"/properties/search?client_id=dev&response_type=xml"
      resp = HTTParty.get(url)
      resp["hash"]["returned_rows"].should == 10
    end
  end


end