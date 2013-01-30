require 'spec_helper'

describe '/listings/search' do

  let(:common_part) {"/listings/search?client_id=dev"}

  it "Return results as XML "  do
    url =  SERVICE_URL+common_part+"&response_type=xml"
    resp = HTTParty.get(url)
    resp["hash"]["returned_rows"].should == 10
  end

  it "Return as json"  do
    url =  SERVICE_URL+common_part
    resp = HTTParty.get(url)
    resp["returned_rows"].should == 10
  end

  it "Return 20 results instead of default 10"  do
    url =  SERVICE_URL+common_part+"&limit=20"
    resp = HTTParty.get(url)
    resp["returned_rows"].should == 20
  end


end
