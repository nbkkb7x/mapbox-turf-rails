# Mapbox + Turf on Rails
This app was originally based off [Rui Freitas' Mapbox Clusters](https://github.com/rodloboz/mapbox-clusters). Thanks Rui for all the Model => GeoJSON goodness. 

### About This Project
Mapbox API is a great mapping & location tool to develop with. However, plotting a geospatial accurate radius can be challenging and require quite a bit of tile & zoom modificaitons to get it to work. [Turf.js](https://turfjs.org/) is a geospatial tool that makes it easy to calculate GeoJSON polygons. Intergrating Turf.js into a Mapbox API on Rails was something that I hadn't been able to find, so I built my own solution. 

### What this App does
Mapbox + Turf on Rails allows a user to create an office location, geocode the address (using [GeoKit](https://github.com/geokit/geokit-rails)), save the record, pass the GeoJSON dataset to Mapbox.js to populate on the Map div. I also utilize Geokit's <code>within_radius</code> method to pass multiple offices that fall within a certain radius param. 

### Some Must-Haves or Good-to-Knows
This app does make a few assumptions. Have these guys handy to help deploy:

- Mapbox API Key
- Any other Geocode API key if you want to use Geokit with another provider
- ENV variables defined somewhere. I use DotENV for this
- CSS Framework is [Skeleton CSS](https://getskeleton.com/), a dead simple boilerplate you can easily remove if you wish. 

### Get Started
1. Git clone this badboy
2. Yarn install
3. Bundle install
4. Add ENV Details (There is a default.env you can use to create your .env file)
5. rake db commands (create, migrate & seed)
6. Rails s

Any questions or help, hit me up on Twitter @somethingkillr or mpope@somethingkiller.com