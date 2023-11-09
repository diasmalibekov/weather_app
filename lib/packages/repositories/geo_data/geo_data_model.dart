abstract class GeoObject {
  final String name;

  GeoObject(this.name);
}

class City extends GeoObject {
  final String region;
  final String regionCode;

  City(super.name, this.region, this.regionCode);
}

class Country extends GeoObject {
  final String code;

  Country(super.name, this.code);
}

class GeoResponseMetadata {
  final int currentOffset;
  final int totalCount;

  GeoResponseMetadata(this.currentOffset, this.totalCount);
}

class GeoResponse<T extends GeoObject> {
  final List<T> data;
  final GeoResponseMetadata metadata;

  GeoResponse(this.data, this.metadata);
}
