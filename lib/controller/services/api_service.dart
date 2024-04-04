import 'dart:convert';

import 'package:get/get.dart';

class ApiProvider extends GetConnect {
  Future<Response> getLocation(double lat, double lon) => get(
      'https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=bbd03f242a5403f7f12ffe96c341dfca');

  Future<Response> getWeatherData(String cityCode) => get(
      "https://us-central1-weather-khln.cloudfunctions.net/getWeatherData?cityCode=$cityCode");

  Future<Response> postUser(email, newEmail, city) => post(
      'https://us-central1-weather-khln.cloudfunctions.net/updateEmail',
      jsonEncode({
        'email': email,
        'newEmail': newEmail,
        'city': city,
      }));
}
