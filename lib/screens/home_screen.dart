import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:weatherapp/controller/services/location_service.dart';
import 'package:weatherapp/controller/services/storage_service.dart';
import 'package:weatherapp/widgets/header.dart';

import '../constants/colors.dart';
import '../controller/services/api_service.dart';
import '../models/weather_api_model.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _controller = ScrollController();
  final LocationService locationService = Get.find();
  final StorageService storageService = Get.find();
  final apiProvider = Get.put(ApiProvider());
  Rxn<WeatherApiModel> weather = Rxn(null);
  RxBool loading = true.obs;
  RxString city = ''.obs;
  RxString email = ''.obs;

  initiateLocation() async {
    String currentCity = storageService.getUserCity();
    if (currentCity.isNotEmpty) {
      city.value = currentCity;
    } else {
      city.value = await locationService.getCurrentCity();
    }
    getWeatherData();
  }

  getWeatherData() async {
    var result = await apiProvider.getWeatherData(city.value);
    if (result.isOk && result.body != null) {
      weather.value = WeatherApiModel.fromJson(
          {...result.body["week"], ...result.body["48"]});
    }
    loading.value = false;
  }

  changeCity(newCity) async {
    apiProvider.postUser(email.value, email.value, newCity);
    storageService.setUserCity(newCity);
    city.value = newCity;
    loading.value = true;
    getWeatherData();
  }

  updateEmail(newValue) async {
    await apiProvider.postUser(email.value, newValue, city.value);
    storageService.setUserEmail(newValue);
    email.value = newValue;
  }

  @override
  void initState() {
    super.initState();
    email.value = storageService.getUserEmail();
    initiateLocation();
  }

  @override
  Widget build(BuildContext context) {
    var colors = getThemeColors();
    return Scaffold(
      body: Obx(
        () => loading.value
            ? const Center(child: CupertinoActivityIndicator())
            : weather.value == null
                ? const SizedBox()
                : CustomScrollView(
                    controller: _controller,
                    slivers: [
                      Obx(
                        () => Header(
                          controller: _controller,
                          cityCode: city.value,
                          data: weather.value,
                          email: email.value,
                          onEmailChanged: updateEmail,
                          onCityChanged: changeCity,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      SliverStickyHeader(
                        header: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          color: colors.BACKGROUND_1,
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.time,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                weather.value?.wxPhraseLong[0] ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.BACKGROUND_1,
                              border: Border(
                                top: BorderSide(
                                  color: colors.SURFACE_HIGH.withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: SizedBox(
                              height: 90,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    weather.value?.validTimeLocal.length ?? 0,
                                itemBuilder: (context, index) {
                                  int iconCode = weather.value!.iconCode[index];
                                  int temperature =
                                      weather.value!.temperature[index];
                                  String time = weather
                                      .value!.validTimeLocal[index]
                                      .toString()
                                      .split("T")
                                      .last
                                      .split(":")
                                      .first;
                                  return hourlyWidget(
                                      iconCode, temperature, time);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(width: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),
                      SliverStickyHeader(
                        header: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          color: colors.BACKGROUND_1,
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.calendar,
                                size: 18,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '7 хоногийн цаг агаарын мэдээ',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.BACKGROUND_1,
                              border: Border(
                                top: BorderSide(
                                  color: colors.SURFACE_HIGH.withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  (weather.value?.dayOfWeek.length ?? 1) - 1,
                              itemBuilder: (context, index) {
                                int maxTemp = weather.value!
                                    .calendarDayTemperatureMax[index + 1];
                                int minTemp = weather.value!
                                    .calendarDayTemperatureMin[index + 1];
                                String day =
                                    weather.value!.dayOfWeek[index + 1];
                                int dayIcon = weather
                                    .value!.weeklyIconCode[(index + 1) * 2];
                                int nightIcon = weather
                                    .value!.weeklyIconCode[(index + 1) * 2 + 1];
                                return dailyWidget(
                                    dayIcon, nightIcon, maxTemp, minTemp, day);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      SliverStickyHeader(
                        header: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          color: colors.BACKGROUND_1,
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.calendar,
                                size: 18,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '7 хоногийн нар мандах болон жаргах',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.BACKGROUND_1,
                              border: Border(
                                top: BorderSide(
                                  color: colors.SURFACE_HIGH.withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  (weather.value?.dayOfWeek.length ?? 1) - 1,
                              itemBuilder: (context, index) {
                                String rise =
                                    weather.value!.sunriseTimeLocal[index + 1];
                                String set =
                                    weather.value!.sunsetTimeLocal[index + 1];
                                String day =
                                    weather.value!.dayOfWeek[index + 1];
                                return dailySunWidget(rise, set, day);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                    ],
                  ),
      ),
    );
  }

  Widget hourlyWidget(int code, int temp, String hour) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 2),
          Text(
            hour,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          getWeatherIcon(code, null),
          const SizedBox(height: 2),
          Text('${((temp - 32) / 1.8).round()}°',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 2),
        ],
      );

  Widget dailyWidget(
          int dayCode, int nightCode, int maxTemp, int minTemp, String date) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              date.split(" ").first,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          getWeatherIcon(dayCode, 40),
          const SizedBox(width: 6),
          getWeatherIcon(nightCode, 40),
          const SizedBox(width: 16),
          SizedBox(
            width: 30,
            child: Text('${((maxTemp - 32) / 1.8).round()}°',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          SizedBox(
            width: 30,
            child: Text('${((minTemp - 32) / 1.8).round()}°',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      );

  Widget dailySunWidget(String rise, String set, String date) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              date.split(" ").first,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Icon(CupertinoIcons.sunrise),
          const SizedBox(width: 6, height: 40),
          SizedBox(
            width: 50,
            child: Text(rise.split("T").last.substring(0, 5),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 16),
          const Icon(CupertinoIcons.sunset),
          const SizedBox(width: 6, height: 40),
          SizedBox(
            width: 50,
            child: Text(set.split("T").last.substring(0, 5),
                style: Theme.of(context).textTheme.bodyMedium),
          )
        ],
      );

  Image getWeatherIcon(int? code, double? size) {
    String path = "assets/images/weather/big/";
    String name = "44";
    if (code != null && code <= 47 && code >= 0) {
      name = code.toString();
    }
    return Image.asset(
      "$path$name.png",
      height: size ?? 30.0,
      width: size ?? 30.0,
    );
  }
}
