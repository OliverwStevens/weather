# app/controllers/concerns/location_helper.rb
module LocationHelper
  extend ActiveSupport::Concern

  def get_lat_lng_from_ip(user_ip)
    
    url = "https://ipapi.co/#{user_ip}/json/"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    output = JSON.parse(response)
    [output['latitude'], output['longitude']]
  end

  def forecast(lat, lng)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lng}&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    report = JSON.parse(response)
    [report["daily"]["temperature_2m_max"], report["daily"]["temperature_2m_min"]]
  end
end
