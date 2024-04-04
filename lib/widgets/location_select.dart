import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/constants/location.dart';
import 'package:weatherapp/models/location_model.dart';
import '../constants/colors.dart';

class LocationSelect extends StatefulWidget {
  final String initialValue;
  final void Function(String value) onChanged;
  const LocationSelect(
      {Key? key, required this.initialValue, required this.onChanged})
      : super(key: key);

  @override
  createState() => _LocationSelectState();
}

class _LocationSelectState extends State<LocationSelect> {
  final colors = getThemeColors();

  onChoose(LocationModel item) {
    widget.onChanged(item.code);
    Navigator.pop(context);
  }

  _showDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
        child: Container(
          width: double.maxFinite,
          height: context.mediaQuerySize.height * 0.8,
          decoration: BoxDecoration(
            color: colors.BACKGROUND_1.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: 60,
                  child: Center(
                    child: Text('Аймаг сонгох',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge),
                  )),
              Container(
                  color: colors.SURFACE_HIGH.withOpacity(0.1),
                  height: 1,
                  width: double.maxFinite),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: areas
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              onChoose(e);
                            },
                            child: SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  e.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: widget.initialValue == e.name
                                            ? colors.SURFACE_HIGH
                                            : colors.SURFACE_HIGH
                                                .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: context.mediaQueryViewPadding.bottom)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDialog,
      child: Row(
        children: [
          Text(
            widget.initialValue,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(width: 12),
          const Icon(Icons.location_on_rounded)
        ],
      ),
    );
  }
}
