// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:local_notification_demo/logger.dart';
import 'package:local_notification_demo/model/set_time_model.dart';
import 'package:local_notification_demo/screen/add_timer_screen.dart';
import 'package:local_notification_demo/services/notification_service.dart';
import 'package:local_notification_demo/utils/date_format.dart';

class ScheduleBtn extends StatelessWidget {
  ScheduleBtn({
    Key? key,
    required this.onTap,
    required this.setTimeModel,
  }) : super(key: key);

  final Function onTap;
  final SetTimeModel setTimeModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        onTap();
      },
    );
  }
}
