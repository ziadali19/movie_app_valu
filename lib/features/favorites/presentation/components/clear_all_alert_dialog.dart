import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';

class ClearAllAlertDialog extends StatelessWidget {
  const ClearAllAlertDialog({
    super.key,
    required this.onCancel,
    required this.onClear,
  });
  final VoidCallback onCancel;
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.cardBackground,
      title: Text(
        'Clear All Favorites',
        style: TextStyle(
          color: ColorsManager.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Are you sure you want to remove all movies from your favorites? This action cannot be undone.',
        style: TextStyle(color: ColorsManager.textSecondary, fontSize: 14.sp),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: ColorsManager.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: onClear,
          child: Text(
            'Clear All',
            style: TextStyle(
              color: ColorsManager.accentRed,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
