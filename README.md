# Bicisendas for iOS

Source code for [Bicisendas iOS](https://itunes.apple.com/us/app/bicisendas/id1427739408?mt=8).

With Bicisendas you can see all the bikelanes available in the City of Buenos Aires,
search for routes from your current location to anywhere in the city, and check the stations for the bikeshare network EcoBici.

## Contributing 

PRs are welcome. Please fork the project, and send a PR to `master`.

## Interting bits

A few bits of the app we consider interesting:

- [USIG](http://usig.buenosaires.gob.ar), which we use their data for routing, doesn't provide a server side API, but a JavaScript one.
  In order to integrate it in a native app, we created [a wrapper](Bicisendas/USIG/USIGWrapper.swift). The wrapper will create
  a hidden `UIWindow` where it will place a `WKWebView` instance. Within that instance, we run [`usig-api.html`](Bicisendas/USIG/usig-api.html)
  that provides an API we can invoke from the iOS side.
- USIG maps uses its own coordinate system, called [Gauss-Kruger Buenos Aires Reproyectado](https://recursos-data.buenosaires.gob.ar/ckan2/proyecciones-gkba.pdf).
  In order to convert coordinates we are using [proj4](https://proj4.org). You can check [`USIGCoordinateHelper.m`](Bicisendas/USIG/USIGCoordinateHelper.m) to see
  how we use it.
