class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show
    @location = Location.find(params[:id])
    weather_service = WeatherService.new(@location)
    @highs, @lows = weather_service.fetch_weather_data

    # If the data is present, proceed as usual
    if @highs.present? && @lows.present?
      highs_data = @highs.join(",")
      lows_data = @lows.join(",")

      require 'date'
      today = Date.today
      @day_names = ["Today"] + (1..6).map { |i| (today + i).strftime("%A") }
      day_names_str = @day_names.join('%7C')

      @chart_url = "https://image-charts.com/chart?chbh=20&chbr=5&chco=E5446D%2C60B2E5&chd=a:#{highs_data}|#{lows_data}&chdl=Highs%7CLows&chdlp=r&chg=5&chs=700x300&cht=bvg&chtt=Temperature%20°F&chxl=0%3A%7C#{day_names_str}&chxt=x%2Cy"
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

   
end
