class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :edit, :update, :destroy]

  # Get /offices
  
  # GET /offices
  # GET /offices.json
  def index
    @offices = Office.where.not(longitude: nil, latitude: nil)
    @geojson = build_geojson
  end

  # GET /offices/1
  # GET /offices/1.json
  def show
  end

  # GET /offices/new
  def new
    @office = Office.new
  end

  # GET /offices/1/edit
  def edit
  end

  # POST /offices
  # POST /offices.json
  def create
    @office = Office.new(office_params)

    respond_to do |format|
      if @office.save
        format.html { redirect_to offices_url, notice: 'Office was successfully created.' }
        format.json { render :show, status: :created, location: @office }
      else
        format.html { render :new }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offices/1
  # PATCH/PUT /offices/1.json
  def update
    respond_to do |format|
      if @office.update(office_params)
        format.html { redirect_to offices_url, notice: 'Office was successfully updated.' }
        format.json { render :show, status: :ok, location: @office }
      else
        format.html { render :edit }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offices/1
  # DELETE /offices/1.json
  def destroy
    @office.destroy
    respond_to do |format|
      format.html { redirect_to offices_url, notice: 'Office was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_office
      @office = Office.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def office_params
      p = params.require(:office).permit(:name, :county, :address_1, :address_2, :city, :state, :zipcode, :humana_market, :full_address, :longitude, :latitude)
      full_address = "#{p[:address_1]}, #{p[:address_2]}, #{p[:city]}, #{p[:state]}, #{p[:zipcode]}"
      geo_code = Geokit::Geocoders::MapboxGeocoder.geocode(full_address)
      p[:longitude] = geo_code.lng 
      p[:latitude] = geo_code.lat
      p[:full_address] = full_address
      return p
    end


    # Build GeoJSON for MapBox Markers
    def build_geojson
      {
        type: "FeatureCollection",
        features: @offices.map(&:to_feature),
        coordinates: @offices.map(&:mapbox_coordinates)
      }
      # binding.pry
    end
end
