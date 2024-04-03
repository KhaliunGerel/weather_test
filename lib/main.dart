import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/controller/services/location_service.dart';
import 'package:weatherapp/controller/services/storage_service.dart';
import 'package:weatherapp/screens/home_screen.dart';

initServices() async {
  await Get.putAsync(() => LocationService().init());
  await Get.putAsync(() => StorageService().init());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
