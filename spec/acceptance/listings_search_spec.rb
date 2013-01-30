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


  it "Request all rental listings between $500 and $1500 rental price"  do
    url =  SERVICE_URL+common_part+"&price_max=1500&price_min=500"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
    resp["listings"].each do |listing|
      if !listing["community"].nil?
        listing["community"]["price_min"].should >= 500
        listing["community"]["price_max"].should <= 1500
      else
        listing["price"].should >= 500
        listing["price"].should <= 1500
      end
    end

  end

  it "Request all rental listings between $500 and $1500 rental price with 3 or more bathrooms and between 700 and 1200 square feet. Sort by square footage high to low"  do
    url =  SERVICE_URL+common_part+"&price_max=1500&price_min=500&baths_min=3&sqft_min=700&sqft_max=1200&sort=sqft_high"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
    current_sqft = 99999999999
    resp["listings"].each do |listing|
      if !listing["community"].nil?
        current_sqft.should >= listing["community"]["sqft_min"]
        current_sqft =  listing["community"]["sqft_min"]
        listing["community"]["price_min"].should >= 500
        listing["community"]["price_max"].should <= 1500
        listing["community"]["baths_min"].should >= 3
        listing["community"]["sqft_max"].should <= 1200
        listing["community"]["sqft_min"].should >= 700
      else
        current_sqft.should >= listing["sqft"]
        current_sqft =  listing["sqft"]
        listing["price"].should >= 500
        listing["price"].should <= 1500
        listing["baths"].should >= 3
        listing["sqft"].should <= 1200
        listing["sqft"].should >= 700
      end
    end

  end



end
