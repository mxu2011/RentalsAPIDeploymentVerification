require 'spec_helper'

describe ' polygonsearch' do

  it "Should not return 500 error "  do

    count = 0
    err_count = 0
    File.open("#{Rails.root}/spec/fixtures/polygon_prod_errors.json").each_line do |line|
      begin
        url= SERVICE_URL + JSON.parse(line)["result"]["http_request"].scan( /GET \/v1\/.+points.+HTTP/)[0].gsub("GET \/v1",'').gsub("HTTP",'')
        resp = HTTParty.get(url)
        resp.should_not nil

        rescue
        puts "ERROR----##{count}:#{line}\n"
        err_count += 1
      end
      count +=1
      puts "#{err_count} out of #{count} failed"
    end



  end


end
