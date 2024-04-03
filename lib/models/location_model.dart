class LocationModel {
  final String code;
  final String geocode;
  final List<double> coordinate;
  LocationModel(this.code, this.geocode, this.coordinate);

  LocationModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        geocode = json['geocode'],
        coordinate = json['coordinate'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'geocode': geocode,
        'coordinate': coordinate,
      };
}
