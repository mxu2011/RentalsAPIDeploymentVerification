require 'spec_helper'

describe '/properties/search' do

  let(:common_part) {"/properties/search?client_id=dev"}

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

  it "Request all rental listings on a specific address"  do
    url =  SERVICE_URL+common_part
    resp = HTTParty.get(url)
    resp["returned_rows"].should == 10
    properties = resp["properties"]
    address = URI.escape(properties[0]["listings"][0]["address"]["line"])
    city = URI.escape(properties[0]["listings"][0]["address"]["city"])
    state_code = URI.escape(properties[0]["listings"][0]["address"]["state_code"])
    url =  SERVICE_URL+common_part+"&address=#{address}&city=#{city}&state_code=#{state_code}"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
  end


  it "Request all rental listings between $500 and $1500 rental price"  do
    url =  SERVICE_URL+common_part+"&price_max=1500&price_min=500"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
    resp["properties"].each do |property|
      if !property["listings"][0]["community"].nil?
        property["listings"][0]["community"]["price_min"].should >= 500
        property["listings"][0]["community"]["price_max"].should <= 1500
      else
        property["listings"][0]["price"].should >= 500
        property["listings"][0]["price"].should <= 1500
      end
    end

  end

  it "Request all rental listings between $500 and $1500 rental price with 3 or more bathrooms and between 700 and 1200 square feet. Sort by square footage high to low"  do
    url =  SERVICE_URL+common_part+"&price_max=1500&price_min=500&baths_min=3&sqft_min=700&sqft_max=1200&sort=sqft_high"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
    current_sqft = 99999999999
    resp["properties"].each do |property|
      if !property["listings"][0]["community"].nil?
        current_sqft.should >= property["listings"][0]["community"]["sqft_min"]
        current_sqft =  property["listings"][0]["community"]["sqft_min"]
        property["listings"][0]["community"]["price_min"].should >= 500
        property["listings"][0]["community"]["price_max"].should <= 1500
        property["listings"][0]["community"]["baths_min"].should >= 3
        property["listings"][0]["community"]["sqft_max"].should <= 1200
        property["listings"][0]["community"]["sqft_min"].should >= 700
      else
        current_sqft.should >= property["listings"][0]["sqft"]
        current_sqft =  property["listings"][0]["sqft"]
        property["listings"][0]["price"].should >= 500
        property["listings"][0]["price"].should <= 1500
        property["listings"][0]["baths"].should >= 3
        property["listings"][0]["sqft"].should <= 1200
        property["listings"][0]["sqft"].should >= 700
      end
    end

  end

  it "Request all listings with a listed date not older than 14 days"  do
    date_check_point = (Time.now-1209600).to_s.to_iso_8601

    url =  SERVICE_URL+common_part+"&listed_date_min=#{date_check_point}"
    resp = HTTParty.get(url)
    resp["returned_rows"].should >0
    resp["properties"].each do |property|
      property["listings"][0]["list_date"].should >= date_check_point
    end

  end

end
