class WeatherService
  def initialize(location)
    @location = location
    @lat = nil
    @lng = nil
  end

  def fetch_weather_data
    fetch_lat_lng
    return unless @lat && @lng

    forecast
  end

  private

  def fetch_lat_lng
    if @location.ip_address.present?
      @lat, @lng = get_lat_lng_from_ip
    elsif @location.zipcode.present?
      @lat, @lng = get_lat_lng_from_zipcode
    end
  end

  def get_lat_lng_from_ip
    Rails.logger.debug("Called IP method, #{@location.ip_address}")
    url = "https://ipapi.co/#{@location.ip_address}/json/"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    output = JSON.parse(response)
    [output['latitude'], output['longitude']]
  end

  def get_lat_lng_from_zipcode
    Rails.logger.debug("Called Zipcode method, #{@location.zipcode}")
    url = "https://geocode.xyz/#{@location.zipcode}?json=1"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    output = JSON.parse(response)
    [output['latt'], output['longt']]
  end

  def forecast
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{@lat}&longitude=#{@lng}&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    report = JSON.parse(response)
    return unless report["daily"].present?

    [report["daily"]["temperature_2m_max"], report["daily"]["temperature_2m_min"]]
  end
end
