import 'package:flutter/material.dart';
import 'package:local_notification_demo/utils/extension.dart';

import 'bottom_nav_button.dart';

class CustomBottomSheet {
  CustomBottomSheet._();
  static final instance = CustomBottomSheet._();
  modalBottomSheet({
    required Widget child,
    required BuildContext context,
    String? bottomButtonName,
    Function? onBottomPressed,
    onCloseButton,
    Color? bottomButtonColor,
  }) {
    // FocusManager.instance.primaryFocus?.unfocus();
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,

        // clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onCloseButton();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                    )),
              ),
              Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.875),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: child,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                        if (bottomButtonName.isNotNullAndEmpty())
                          BottomNavButton(
                              text: bottomButtonName!,
                              bgColor: bottomButtonColor,
                              onPressed: onBottomPressed ?? () {})
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
