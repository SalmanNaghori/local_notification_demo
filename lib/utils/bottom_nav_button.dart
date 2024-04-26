import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_notification_demo/utils/app_util.dart';

class BottomNavButton extends StatelessWidget {
  String text;
  Color? bgColor, textColor;
  double? height;
  String? icon;
  Color? buttonTextColor;
  double? elevation;
  Function onPressed;

  BottomNavButton({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.height,
    this.bgColor,
    this.icon,
    this.buttonTextColor,
    this.elevation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onPressed();
      },
      child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom == 0
                  ? 0
                  : Platform.isAndroid
                      ? MediaQuery.of(context).padding.bottom
                      : 12),
          color: Colors.deepPurpleAccent,
          height: AppUtils.instance.bottomPadding(context),
          width: double.infinity,
          child: Center(
              child: Text(
            text,
          ))),
    );
  }
}
