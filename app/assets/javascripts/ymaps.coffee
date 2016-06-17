window.ya_init = ->
  $('.ymap').not('.done').addClass('done').each ->
    $m = $(this)
    ymaps.geocode($m.data('address'), {results: 1}).then (res) ->
      firstGeoObject = res.geoObjects.get(0)
      coords = firstGeoObject.geometry.getCoordinates()
      map = new ymaps.Map("map",
        center: coords
        zoom: 15,
        behaviors: ['default'] #, 'scrollZoom']
      )
      map.controls.add('zoomControl', { left: 5, top: 5 })
      myPlacemark = new ymaps.Placemark(coords)
      map.geoObjects.add(myPlacemark)

$ ->
  return if $('.ymap').not('.done').length == 0
  if window.ymaps
    ya_init()
  else
    $.getScript( "//api-maps.yandex.ru/2.1/?load=package.full&lang=ru-RU&oload=ya_init")
