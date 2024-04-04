import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:weatherapp/constants/colors.dart';
import 'package:weatherapp/constants/location.dart';
import 'package:weatherapp/widgets/email_subscription.dart';
import 'package:weatherapp/widgets/location_select.dart';

import '../models/weather_api_model.dart';

class Header extends StatefulWidget {
  final ScrollController controller;
  final WeatherApiModel? data;
  final String cityCode;
  final String email;
  final void Function(String value) onCityChanged;
  final void Function(String value) onEmailChanged;
  const Header(
      {Key? key,
      required this.controller,
      required this.cityCode,
      required this.onCityChanged,
      required this.onEmailChanged,
      this.data,
      this.email = ''})
      : super(key: key);
  @override
  createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late ScrollController _controller;
  RxDouble weatherHeight = 0.0.obs;
  RxDouble weatherOpacity = 1.0.obs;
  var weatherMin = 130.0;
  var weatherMax = 250.0;
  var weatherHide = 160.0;

  @override
  void initState() {
    super.initState();
    weatherHeight = weatherMax.obs;
    _controller = widget.controller;
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset >= weatherMin && weatherHeight < weatherMin) return;
    double tempHeight = weatherMax - _controller.offset;
    if (tempHeight == weatherHeight.value) return;
    double tempOpacity =
        (tempHeight - weatherHide) * 100 / (weatherMax - weatherHide);
    if (tempOpacity < 0) tempOpacity = 0.0;
    if (tempOpacity > 100) tempOpacity = 100.0;
    weatherHeight.value = max(tempHeight, weatherMin);
    weatherOpacity.value = tempOpacity * 0.01;
  }

  Image getBigImage(int? code, double percentage) {
    String path = "assets/images/weather/big/";
    String name = "44";
    if (code != null && code <= 47 && code >= 0) {
      name = code.toString();
    }
    return Image.asset(
      "$path$name.png",
      height: weatherHide * percentage,
      width: weatherHide * percentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = getThemeColors();
    var cityName =
        areas.firstWhereOrNull((a) => a.code == widget.cityCode)?.name ?? '';
    return Obx(
      () {
        var percentage = min(weatherHeight.value / (weatherHide + 20), 1.0);
        return SliverAppBar(
          pinned: true,
          expandedHeight: kToolbarHeight,
          collapsedHeight: kToolbarHeight,
          backgroundColor: colors.PRIMARY,
          foregroundColor: colors.PRIMARY,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              color: colors.PRIMARY,
            ),
          ),
          title: Row(
            children: [
              EmailSubscription(
                initialValue: widget.email,
                onChanged: widget.onEmailChanged,
              )
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(weatherHeight.value),
            child: Container(
              width: double.maxFinite,
              height: weatherHeight.value,
              color: colors.PRIMARY,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${(((widget.data?.temperature[0] ?? 0) - 32) / 1.8).round()}°',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(fontSize: 72 * percentage),
                              ),
                              LocationSelect(
                                  initialValue: cityName,
                                  onChanged: widget.onCityChanged)
                            ],
                          ),
                        ),
                        (widget.data?.iconCode ?? []).isEmpty ||
                                widget.data?.iconCode[0] == null
                            ? SizedBox(width: weatherMin * percentage)
                            : getBigImage(widget.data?.iconCode[0], percentage),
                      ],
                    ),
                    Opacity(
                      opacity: weatherOpacity.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/weather/wind.svg',
                                  color: colors.SURFACE_HIGH),
                              const SizedBox(width: 8),
                              Text('${widget.data?.windSpeed[0]} м/с',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(width: 16),
                              SvgPicture.asset(
                                  'assets/images/weather/humidity.svg',
                                  color: colors.SURFACE_HIGH),
                              const SizedBox(width: 8),
                              Text('${widget.data?.relativeHumidity[0]} %',
                                  style: Theme.of(context).textTheme.bodyLarge)
                            ],
                          ),
                          Text(widget.data?.narrative[0] ?? ''),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
