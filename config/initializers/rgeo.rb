RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  # Установите правильную геометрическую фабрику для модели House
  config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: 'point')
end
