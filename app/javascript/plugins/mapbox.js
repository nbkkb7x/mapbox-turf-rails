
import mapboxgl from '!mapbox-gl';
import * as turf from '@turf/turf';

const fitMapToMarkers = (map, features) => {
  const bounds = new mapboxgl.LngLatBounds();
  features.forEach(({ geometry }) => bounds.extend(geometry.coordinates));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    map.on('load', function() {
      const offices = JSON.parse(mapElement.dataset.offices);
      var radius = 30;
      var options = {
        steps: 80,
        units: 'miles'
      };
      
      var circles = offices.coordinates.map(e => 
        turf.circle(e, radius, options)
      );
      const office_circles = {
        'type': 'FeatureCollection',
        'features': circles
      };

      map.addSource('offices', {
        type: 'geojson',
        data: offices
      });

      map.addSource('office_circles', {
        type: 'geojson',
        data: office_circles
      });

      // Add a new layer to visualize the polygon.
      map.addLayer({
          'id': 'radius_fill',
          'type': 'fill',
          'source': 'office_circles', // reference the data source
          'layout': {},
          'paint': {
          'fill-color': '#3598D4', // blue color fill
          'fill-opacity': 0.20
        }
      });
        // Add a black outline around the polygon.
        map.addLayer({
          'id': 'radius_outline',
          'type': 'line',
          'source': 'office_circles',
          'layout': {},
          'paint': {
          'line-color': '#1C2226',
          'line-width': .5
          }
        });

      
      map.addLayer({
        id: 'office_point',
        type: 'circle',
        source: 'offices',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': '#145E8C',
          'circle-radius': 5,
          'circle-stroke-width': 1,
          'circle-stroke-color': '#F2F2F2'
        }
      });


      map.on('mouseenter', 'clusters', function (e) {
        map.getCanvas().style.cursor = 'pointer';
      });

      map.on('mouseleave', 'clusters', function () {
        map.getCanvas().style.cursor = '';
      });

      map.on('click', 'office_point', function (e) {
        const features = map.queryRenderedFeatures(e.point, { layers: ['office_point'] });
        const infoWindow = features[0].properties.info_window;
        const coordinates = features[0].geometry.coordinates;

        map.easeTo({
          center: features[0].geometry.coordinates
        });

        new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(infoWindow)
          .addTo(map);
      });

      map.on('mouseenter', 'office_circle', function () {
        map.getCanvas().style.cursor = 'pointer';
      });

      map.on('mouseleave', 'office_circle', function () {
        map.getCanvas().style.cursor = '';
      });

      fitMapToMarkers(map, offices.features);
    });
  }
};

export { initMapbox };