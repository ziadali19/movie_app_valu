import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DetailsInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailsInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyles.font14Primary700.copyWith(
                color: ColorsManager.textSecondary,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              style: TextStyles.font14Primary700.copyWith(
                color: ColorsManager.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
