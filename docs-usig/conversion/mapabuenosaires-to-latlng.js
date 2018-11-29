// Número definido según lo que devuelve
// miMapa.api.getProjection().
Proj4js.defs["EPSG:221951"] = "+proj=tmerc +lat_0=-34.6297166 +lon_0=-58.4627 +k=0.9999980000000001 +x_0=100000 +y_0=100000 +ellps=intl +towgs84=-148,136,90,0,0,0,0 +units=m +no_defs";

/**
 * Convierte una coordenada en la proyección utilizada por
 * el Mapa Interactivo de Buenos Aires a latitud longitud WGS84
 * @param {Number} x. La coordenada x (Esto suele llamarse longitud pero en esta proyección no se puede hablar de longitud)* @param {Number} x. La coordenada x (Esto suele llamarse longitud pero en esta proyección no se puede hablar de longitud)
 * @param {Number} x. La coordenada y (Esto suele llamarse latitud pero en esta proyección no se puede hablar de longitud)* @param {Number} x. La coordenada x (Esto suele llamarse longitud pero en esta proyección no se puede hablar de latitud)
 * OR
 * @param {OpenLayers.LonLat} point. un punto LonLat de OpenLayers.
 * OR
 * @param {Proj4js.Point} point. un punto x, y de Proj4JS.
 *
 * @returns {Object}. Latitud y longitud en WGS84 del punto.
 *   - {Float} lat.
 *   - {Float} lng.
 */
function mapaBuenosAiresToLatLng(x, y) {
  var point,
    sourceProj = new Proj4js.Proj("EPSG:221951"),
    destProj = new Proj4js.Proj("EPSG:4326");
  if (window.OpenLayers && (arguments[0] instanceof OpenLayers.LonLat)) {
    point = arguments[0];
    point = new Proj4js.Point(point.lon, point.lat);
  } else if (arguments[0] instanceof Proj4js.Point) {
    point = arguments[0];
  } else if (arguments.length == 2) {
    point = new Proj4js.Point(x, y);
  } else if (arguments.length == 1 || arguments.length == 0) {
    console.log("mapaBuenosAiresToLatLng necesita los parámetros X e Y para calcular la lat long");
    return undefined;
  }

  var lonLat = Proj4js.transform(sourceProj, destProj, point);
  return {
    lat: lonLat.y,
    lon: lonLat.x,
  }
}

function latLngToMapaBuenosAires(x, y) {
  var point,
    sourceProj = new Proj4js.Proj("EPSG:4326"),
    destProj = new Proj4js.Proj("EPSG:221951");
  if (window.OpenLayers && (arguments[0] instanceof OpenLayers.LonLat)) {
    point = arguments[0];
    point = new Proj4js.Point(point.lon, point.lat);
  } else if (arguments[0] instanceof Proj4js.Point) {
    point = arguments[0];
  } else if (arguments.length == 2) {
    point = new Proj4js.Point(x, y);
  } else if (arguments.length == 1 || arguments.length == 0) {
    console.log("mapaBuenosAiresToLatLng necesita los parámetros X e Y para calcular la lat long");
    return undefined;
  }

  var lonLat = Proj4js.transform(sourceProj, destProj, point);
  return {
    lat: lonLat.y,
    lon: lonLat.x,
  }
}
