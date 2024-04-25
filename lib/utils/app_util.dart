import 'package:flutter/material.dart';

class AppUtils {
  AppUtils._();

  static final instance = AppUtils._();

  double bottomPadding(BuildContext context) {
    // print("bottomPadding    ${buttonHeight(context)}");
    return buttonHeight(context) + (MediaQuery.of(context).padding.bottom * .7);
  }

  double buttonHeight(BuildContext context) {
    // print("AppBar().preferredSize.height    ${AppBar().preferredSize.height}");
    return AppBar().preferredSize.height;
  }
}
