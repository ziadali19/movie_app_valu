import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

void showSnackBar(String? msg, BuildContext context, bool isSuccess) {
  if (msg == null || msg.isEmpty) return;

  // Remove any existing snackbar
  ScaffoldMessenger.of(context).clearSnackBars();

  final snackBar = SnackBar(
    content: Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              msg,
              style: TextStyles.font14White600.copyWith(
                fontFamily: 'IBMPlexSans',
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: isSuccess ? ColorsManager.primary : Colors.red.shade600,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: 40.h, left: 16.w, right: 16.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    duration: const Duration(seconds: 4),
    elevation: 8,
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white.withOpacity(0.8),
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
