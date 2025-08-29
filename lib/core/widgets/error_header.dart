import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/spacing.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';

class ErrorHeader extends StatelessWidget {
  final String errorMessage;
  final void Function()? onRetry;

  const ErrorHeader({super.key, required this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      color: ColorsManager.primary.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: ColorsManager.primary, size: 16.sp),
          horizontalSpace(8.w),
          Expanded(
            child: Text(errorMessage, style: TextStyles.font12Primary500),
          ),
          GestureDetector(
            onTap: onRetry,

            child: Text(
              'Retry',
              style: TextStyles.font12Primary500.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
