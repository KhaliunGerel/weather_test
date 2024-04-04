import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/models/location_model.dart';
import 'package:weatherapp/widgets/textfield.dart';
import '../constants/colors.dart';

class EmailSubscription extends StatefulWidget {
  final String initialValue;
  final void Function(String value) onChanged;
  const EmailSubscription(
      {Key? key, required this.initialValue, required this.onChanged})
      : super(key: key);

  @override
  createState() => _EmailSubscriptionState();
}

class _EmailSubscriptionState extends State<EmailSubscription> {
  final colors = getThemeColors();
  var value = '';

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
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.maxFinite,
          height: context.mediaQuerySize.height * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: colors.BACKGROUND_1.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: Text('Имейл хаяг бүртгэх',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              Container(
                  color: colors.SURFACE_HIGH.withOpacity(0.1),
                  height: 1,
                  width: double.maxFinite),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Та имейл хаягаа оруулснаар өдөр тутмын цаг агаарын мэдээллийг авах боломжтой.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                initialValue: widget.initialValue,
                placeholder: 'Имейл хаягаа оруулна уу',
                type: TextInputType.emailAddress,
                onChanged: (vlu) {
                  setState(() {
                    value = vlu;
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.maxFinite,
                child: MaterialButton(
                  height: 44,
                  color: colors.PRIMARY,
                  splashColor: colors.PRIMARY.withOpacity(0.9),
                  onPressed: () {
                    if (value.isNotEmpty) {
                      widget.onChanged(value);
                    }
                    Get.back();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Хадгалах',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(height: context.mediaQueryViewPadding.bottom)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _showDialog,
      icon: Icon(
        Icons.email_rounded,
        color: colors.SURFACE_HIGH,
      ),
    );
  }
}
