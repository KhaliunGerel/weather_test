import 'package:get/get.dart';

class ApiProvider extends GetConnect {
  Future<Response> getLocation(double lat, double lon) => get(
      'https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=${lon}&limit=1&appid=bbd03f242a5403f7f12ffe96c341dfca');
}
