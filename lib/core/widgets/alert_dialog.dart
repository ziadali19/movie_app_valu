import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

AlertDialog alertDialog(
    BuildContext context,
    String title,
    String acceptText,
    String rejectText,
    String bodyText,
    Widget? icon,
    void Function()? onPressedForAccept,
    void Function()? onPressedForReject) {
  return AlertDialog(
    contentTextStyle: TextStyles.font16Black500,
    titleTextStyle: TextStyles.font18Black500,
    actionsPadding: EdgeInsets.only(bottom: 15.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    title: Text(
      title,
    ),
    icon: icon,
    contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r))),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor:
                    const WidgetStatePropertyAll(ColorsManager.primary)),
            onPressed: onPressedForAccept,
            child: Text(acceptText,
                style: TextStyles.font16Black500.copyWith(color: Colors.white)),
          ),
          ElevatedButton(
            style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r))),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor:
                    const WidgetStatePropertyAll(ColorsManager.secondary)),
            onPressed: onPressedForReject,
            child: Text(
              rejectText,
              style: TextStyles.font16Black500,
            ),
          )
        ],
      )
    ],
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          color: Colors.black,
        ),
        Text(
          bodyText,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
