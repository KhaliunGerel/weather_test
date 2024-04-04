class WeatherApiModel {
  final List<int> iconCode;
  final List<int> relativeHumidity;
  final List<int> temperature;
  final List<int> windSpeed;
  final List<dynamic> validTimeLocal;
  final List<dynamic> wxPhraseLong;

  //WEEK
  final List<int> calendarDayTemperatureMax;
  final List<int> calendarDayTemperatureMin;
  final List<String> dayOfWeek;
  final List<int> weeklyIconCode;
  final List<String> narrative;
  final List<String> sunriseTimeLocal;
  final List<String> sunsetTimeLocal;

  WeatherApiModel(
      this.iconCode,
      this.relativeHumidity,
      this.temperature,
      this.windSpeed,
      this.validTimeLocal,
      this.wxPhraseLong,
      this.calendarDayTemperatureMax,
      this.calendarDayTemperatureMin,
      this.dayOfWeek,
      this.weeklyIconCode,
      this.narrative,
      this.sunriseTimeLocal,
      this.sunsetTimeLocal);

  WeatherApiModel.fromJson(Map<String, dynamic> json)
      : iconCode = json['iconCode'].cast<int>(),
        relativeHumidity = json['relativeHumidity'].cast<int>(),
        temperature = json['temperature'].cast<int>(),
        windSpeed = json['windSpeed'].cast<int>(),
        validTimeLocal = json['validTimeLocal'],
        wxPhraseLong = json['wxPhraseLong'],
        calendarDayTemperatureMax =
            json['calendarDayTemperatureMax'].cast<int>(),
        calendarDayTemperatureMin =
            json['calendarDayTemperatureMin'].cast<int>(),
        dayOfWeek = json['dayOfWeek'].cast<String>(),
        weeklyIconCode = json['daypart']?[0]?['iconCode'].cast<int>(),
        narrative = json['narrative'].cast<String>(),
        sunriseTimeLocal = json['sunriseTimeLocal'].cast<String>(),
        sunsetTimeLocal = json['sunsetTimeLocal'].cast<String>();

  Map<String, dynamic> toJson() => {
        'iconCode': iconCode,
        'relativeHumidity': relativeHumidity,
        'temperature': temperature,
        'windSpeed': windSpeed,
        'validTimeLocal': validTimeLocal,
        'wxPhraseLong': wxPhraseLong,
        'calendarDayTemperatureMax': calendarDayTemperatureMax,
        'calendarDayTemperatureMin': calendarDayTemperatureMin,
        'dayOfWeek': dayOfWeek,
        'narrative': narrative,
        'weeklyIconCode': weeklyIconCode,
        'sunriseTimeLocal': sunriseTimeLocal,
        'sunsetTimeLocal': sunsetTimeLocal,
      };
}
