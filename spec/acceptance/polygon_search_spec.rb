require 'spec_helper'

describe ' polygonsearch' do

  it "Should not return 500 error "  do
    url =  SERVICE_URL

    File.open("#{Rails.root}/spec/fixtures/polygon_prod_errors.json").each_line do |line|
      puts line
      url+=JSON.parse(line)["result"]["http_request"].scan( /GET \/v1\/.+points.+HTTP/)[0].gsub("GET \/v1",'').gsub("HTTP",'')

      resp = HTTParty.get(url)
      resp.should_not nil
    end

  end


end
