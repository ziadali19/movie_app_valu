import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import '../theming/styles.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: ColorsManager.primary),
          SizedBox(width: 20.w),
          Container(
            margin: EdgeInsets.only(left: 7.w),
            child: Text('Loading...', style: TextStyles.font16Black500),
          ),
        ],
      ),
    );
  }
}
