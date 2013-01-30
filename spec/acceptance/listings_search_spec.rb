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


  it "Return 20 results instead of default 10 starting at page 3 (offset=[0.. 1.. 2]) "  do
    url =  SERVICE_URL+common_part+"&limit=20&offset=2"
    resp = HTTParty.get(url)
    resp["returned_rows"].should == 20
  end

  it "Request Community Listings which are Showcase and allow cats"  do
    url =  SERVICE_URL+common_part+"&cats=true&type=community&showcase=true"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
  end

  it "Request all rental listings on McDowell Rd in Avondale, AZ"  do
    url =  SERVICE_URL+common_part+"&address=\"McDowell Rd\"&city=\"Avondale\"&state_code=\"AZ\""
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
  end



end
