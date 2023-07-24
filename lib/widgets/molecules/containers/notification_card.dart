import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../atoms/app_label.dart';
import 'package:parkfinda_mobile/model/notification.dart' as notify;

class NotificationCard extends StatelessWidget {
  final notify.Notification notification;
  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: !notification.isViewed!
            ? AppColors.appColorLightBlue.withOpacity(0.2)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLabel(
                text: notification.title ?? '-',
                textColor: AppColors.appColorBlack,
              ),
              AppLabel(
                text: notification.description ?? '-',
                textColor: AppColors.appColorBlack,
                fontSize: 12,
              ),
              SizedBox(
                height: 20,
              ),
              AppLabel(
                text: notification.date ?? '-',
                fontSize: 14,
                textColor: AppColors.appColorBlack01,
              )
            ],
          ),
        ),
      ),
    );
  }
}
