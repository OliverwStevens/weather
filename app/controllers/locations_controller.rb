class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
    @location = Location.find(params[:id])

    #Get the longitude and lattitude
    if @location.ip_address.present?
      puts "ip address present"
      @lat, @lng = get_lat_lng_from_ip
      puts "Lattitude: #{@lat}, Longitude: #{@lng}"
    elsif @location.zipcode.present?
      puts "zip code is present, #{@location.zipcode}"
      @lat, @lng = get_lat_lng_from_zipcode
      puts "Lattitude: #{@lat}, Longitude: #{@lng}"
    end

    if @lat.present? && @lng.present?
      @highs, @lows = forecast
      puts "Highs: #{@highs} Lows: #{@lows}"
      highs_data = @highs.join(",")
      lows_data = @lows.join(",")


      
      #@chart_url = "https://image-charts.com/chart?cht=bvg&chbr=10&chs=700x100&chd=t:#{highs_data}|#{lows_data}&chco=E5446D,60B2E5"
      #@chart_url = "https://image-charts.com/chart?chbh=20&chbr=10&chco=E5446D%2C60B2E5&chd=t:#{highs_data}|#{lows_data}&chdl=Highs%7CLows&chdlp=r&chg=5&chs=700x300&cht=bvg&chtt=Temperature&chxl=0%3A%7CJan%7CFev%7CMar%7CAvr%7CMay&chxt=x%2Cy"


      require 'date'

      # Get today's date
      today = Date.today

      # Array to hold the day names
      @day_names = ["Today"]

      # Loop to get today and the next 6 days
      (1..6).each do |i|
        @day_names << (today + i).strftime("%A")
      end

      # Join the day names with | for the URL
      day_names_str = @day_names.join('%7C')

      # Update the @chart_url
      @chart_url = "https://image-charts.com/chart?chbh=20&chbr=10&chco=E5446D%2C60B2E5&chd=t:#{highs_data}|#{lows_data}&chdl=Highs%7CLows&chdlp=r&chg=5&chs=700x300&cht=bvg&chtt=Temperature%20°F&chxl=0%3A%7C#{day_names_str}&chxt=x%2Cy"




    end
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_path, status: :see_other, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.expect(location: [ :zipcode, :ip_address ])
    end


    def get_lat_lng_from_ip
    
      puts "Called IP method, #{@location.ip_address}"
      url = "https://ipapi.co/#{@location.ip_address}/json/"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      output = JSON.parse(response)
      [output['latitude'], output['longitude']]
    end
  
  
    def get_lat_lng_from_zipcode
    
      puts "Called Zipcode method, #{@location.zipcode}"
      url = "https://geocode.xyz/#{@location.zipcode}?json=1"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      output = JSON.parse(response)
      [output['latt'], output['longt']]
    end

    def forecast
      
      if @lat.present? && @lng.present? && valid_lat_lng?(@lat, @lng)
        url = "https://api.open-meteo.com/v1/forecast?latitude=#{@lat}&longitude=#{@lng}&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        report = JSON.parse(response)
        [report["daily"]["temperature_2m_max"], report["daily"]["temperature_2m_min"]]
      else
        # Handle invalid or missing latitude and longitude
        Rails.logger.warn("Invalid or missing latitude/longitude: lat=#{@lat}, lng=#{@lng}")
      end
      
    end

    def valid_lat_lng?(lat, lng)
      puts "#{lat}"
      lat.to_f.between?(-90, 90) && lng.to_f.between?(-180, 180)
    end
    
end
