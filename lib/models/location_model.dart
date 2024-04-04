class LocationModel {
  final String code;
  final String name;
  final String geocode;
  final List<double> coordinate;
  LocationModel(this.code, this.name, this.geocode, this.coordinate);

  LocationModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'],
        geocode = json['geocode'],
        coordinate = json['coordinate'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'geocode': geocode,
        'coordinate': coordinate,
      };
}
