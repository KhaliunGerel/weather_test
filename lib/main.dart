import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/controller/services/location_service.dart';
import 'package:weatherapp/controller/services/storage_service.dart';
import 'package:weatherapp/screens/home_screen.dart';

import 'constants/colors.dart';

final darkColors = ColorsDark();
final lightColors = ColorsLight();

initServices() async {
  await Get.putAsync(() => LocationService().init());
  await Get.putAsync(() => StorageService().init());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final lightTheme = ThemeData(
    fontFamily: 'Manrope',
    brightness: Brightness.light,
    primaryColor: lightColors.PRIMARY,
    canvasColor: lightColors.PRIMARY,
    scaffoldBackgroundColor: lightColors.PRIMARY,
    dialogBackgroundColor: lightColors.BACKGROUND_1,
    appBarTheme: AppBarTheme(
      color: lightColors.PRIMARY,
      foregroundColor: lightColors.SURFACE_HIGH,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: lightColors.PRIMARY,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 72,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: lightColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  final darkTheme = ThemeData(
    fontFamily: 'Manrope',
    brightness: Brightness.dark,
    primaryColor: darkColors.PRIMARY,
    canvasColor: darkColors.PRIMARY,
    scaffoldBackgroundColor: darkColors.PRIMARY,
    dialogBackgroundColor: darkColors.BACKGROUND_1,
    appBarTheme: AppBarTheme(
      color: darkColors.PRIMARY,
      foregroundColor: darkColors.SURFACE_HIGH,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: darkColors.PRIMARY,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 72,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: darkColors.SURFACE_HIGH,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: DateTime.now().hour >= 7 && DateTime.now().hour < 20
          ? ThemeMode.light
          : ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
