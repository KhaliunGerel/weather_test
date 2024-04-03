import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp/constants/location.dart';

import 'api_service.dart';

class LocationService extends GetxService {
  static LocationService get to => Get.find();
  late LocationPermission permission;
  late bool serviceEnabled;
  Position? position;

  Future<LocationService> init() async {
    await requestPermission();
    return this;
  }

  Future<void> requestPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getCurrentCity() async {
    try {
      final apiProvider = Get.put(ApiProvider());
      if (position != null) {
        var positionCity = await apiProvider.getLocation(
            position!.latitude, position!.longitude);
        var geocode = positionCity.body[0]['state'] ??
            positionCity.body[0]['local_names']['en'];
        return areas.firstWhereOrNull((e) => e.geocode == geocode)?.code ??
            defaultCity;
      } else {
        throw "";
      }
    } catch (e) {
      return defaultCity;
    }
  }
}
