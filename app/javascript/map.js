var myMap;
ymaps.ready(init);

var userMarkers; // Коллекция меток пользователя
var backendMarkers; // Коллекция меток бекенда

function getHouses(topRightCoords, bottomLeftCoords) {
  const params = new URLSearchParams();
  params.append('topRightCoords', topRightCoords.join(','));
  params.append('bottomLeftCoords', bottomLeftCoords.join(','));

  fetch(`/houses?${params.toString()}`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': currentUserToken
    }
  })
  .then(response => response.json())
  .then(data => {
    // Удаление предыдущих меток бекенда с карты
    myMap.geoObjects.remove(backendMarkers);

    // Создание новой коллекции меток бекенда
    backendMarkers = new ymaps.GeoObjectCollection();

    // Добавление новых меток на карту
    data.forEach(house => {
      var houseCoords = house.location.replace('POINT (', '').replace(')', '').split(' ');
      var houseAddress = house.address;

      var placemark = new ymaps.Placemark(houseCoords, { hintContent: houseAddress }, {
        preset: 'islands#greenDotIcon' // Зеленая иконка для меток бекенда
      });

      // Обработчик события click на Placemark
      placemark.events.add('click', function() {
        // Переход на другую страницу
        window.location.href = `/houses/${house.id}`;
      });

      backendMarkers.add(placemark); // Добавление метки в коллекцию backendMarkers
    });

    // Добавление коллекции меток бекенда на карту
    myMap.geoObjects.add(backendMarkers);
  })
  .catch(error => {
    console.log(error);
    // Обработка ошибок, если необходимо
  });
}

function updateMapMarkers() {
  // Вывод широты и долготы правого верхнего угла карты
  var mapBounds = myMap.getBounds();
  var mapBoundsTopRight = mapBounds[1];
  var topRightLatitude = mapBoundsTopRight[0];
  var topRightLongitude = mapBoundsTopRight[1];

  // Вывод широты и долготы левого нижнего угла карты
  var mapBoundsBottomLeft = mapBounds[0];
  var bottomLeftLatitude = mapBoundsBottomLeft[0];
  var bottomLeftLongitude = mapBoundsBottomLeft[1];

  getHouses([topRightLatitude, topRightLongitude], [bottomLeftLatitude, bottomLeftLongitude]);
}

function coordinateSelectionProcessing() {
  // По клику на карте добавляем маркер
  myMap.events.add('click', function (e) {
    var coords = e.get('coords');

    myMap.geoObjects.remove(userMarkers)

    userMarkers = new ymaps.GeoObjectCollection();

    // Создаем новую метку пользователя
    var placemark = new ymaps.Placemark(coords, {}, {
      draggable: true,
      preset: 'islands#redDotIcon' // Красная иконка для пользовательской метки
    });

    userMarkers.add(placemark);

    myMap.geoObjects.add(userMarkers);

    // При перемещении маркера обновляем координаты в полях формы
    placemark.events.add('dragend', function() {
      var newCoords = placemark.geometry.getCoordinates();
      $('#house_latitude').val(newCoords[0]);
      $('#house_longitude').val(newCoords[1]);
    });

    // Получаем адрес по координатам метки
    ymaps.geocode(coords).then(function (res) {
      // Записываем адрес в поле формы
      $('#house_address').val(res.geoObjects.get(0).getAddressLine());
    });

    // Записываем координаты в поля формы
    $('#house_latitude').val(coords[0]);
    $('#house_longitude').val(coords[1]);
  });
}


function init() {
  myMap = new ymaps.Map('map', mapOptions);

  if (indicatorsOnMap['registeredHouses']) {
    updateMapMarkers()

    // Обновление координат при изменении границ карты
    myMap.events.add('boundschange', function () {
      updateMapMarkers()
    });
  }

  if (indicatorsOnMap['userLabels']) {
    coordinateSelectionProcessing()
  }

  if (indicatorsOnMap['markInMiddle']) {
    var placemark = new ymaps.Placemark(mapOptions.center, {}, {
      draggable: true,
      iconLayout: ymaps.templateLayoutFactory.createClass('<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg"><circle cx="16" cy="16" r="14" fill="#F96167" /></svg>'),
      iconShape: {
        type: 'Circle',
        coordinates: [0, 0],
        radius: 16
      },
      iconOffset: [-16, -16] // Смещение иконки на половину её размера
    });

    myMap.geoObjects.add(placemark);
  }
}
