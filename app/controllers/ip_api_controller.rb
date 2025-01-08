class IpApiController < ApplicationController
  require 'net/http'
  require 'json'

  include LocationHelper
  def index
    user_ip = request.remote_ip
    if user_ip == "::1"
      user_ip = "8.8.8.8"
    end

    @lat, @lng = get_lat_lng_from_ip(user_ip)

    @report = forecast(@lat, @lng)
  end
end
