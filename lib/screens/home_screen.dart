import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controller/services/location_service.dart';
import 'package:weatherapp/controller/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService locationService = Get.find();
  final StorageService storageService = Get.find();
  RxString city = ''.obs;

  initiateLocation() async {
    String currentCity = storageService.getUserCity();
    if (currentCity.isNotEmpty) {
      city.value = currentCity;
    } else {
      city.value = await locationService.getCurrentCity();
    }
  }

  @override
  void initState() {
    super.initState();
    initiateLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(locationService.serviceEnabled.toString()),
              Obx(() => Text(city.value))
            ],
          ),
        ),
      ),
    );
  }
}
