class Office < ApplicationRecord
  acts_as_mappable  :default_units => :miles,
                    :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude,
                    :geocode=>{:field=>:full_address, :error_message=>'Could not geocode address'}

  # Coordinate for GeoKit to Use.                  
  def coordinates
    [latitude, longitude]
  end

  def within_radius
    Office.within(30, :origin => coordinates)
  end

  # I have no idea why Mapbox flips these, but I'm passing them in like this.
  def mapbox_coordinates
    [longitude, latitude]
  end

  # Compiles Office Points into a Friendly Mapbox Format
  def to_feature
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": mapbox_coordinates
      },
      "properties": {
        "office_id": id,
        "name": name,
        "info_window": ApplicationController.new.render_to_string(
          partial: "offices/infowindow",
          locals: { office: self }
        )
        
      }
    }
  end

end
