require 'spec_helper'

describe "listings/search" do

  before do

  end

  describe '/listings/search?client_id=dev&resposne_type=xml' do

    it "Return results as XML "  do
      url =  SERVICE_URL+"/listings/search?client_id=dev&response_type=xml"
      resp = HTTParty.get(url)
      resp["hash"]["returned_rows"].should == 10
    end
  end


end