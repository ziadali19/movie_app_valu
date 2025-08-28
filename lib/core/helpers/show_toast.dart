import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';

showSnackBar(String? msg, BuildContext context, bool greenOrRed) {
  showToast(
    msg,
    context: context,
    textStyle: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
      color: Colors.white,
    ),
    backgroundColor: greenOrRed ? ColorsManager.primary : Colors.red,
    animation: StyledToastAnimation.slideFromTopFade,
    reverseAnimation: StyledToastAnimation.fade,
    position: const StyledToastPosition(
      align: Alignment.bottomCenter,
      offset: 70,
    ),
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 5),
    curve: Curves.bounceOut,
    reverseCurve: Curves.linear,
  );
}
