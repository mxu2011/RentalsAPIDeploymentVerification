require 'test_helper'
require 'rails/performance_test_help'

class ListingsSearchTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_listings_search
    common_part = "/listings/search?client_id=dev"
    url =  SERVICE_URL+common_part
    HTTParty.get(url)
  end
end
