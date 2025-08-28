import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app_valu/core/helpers/extensions.dart';

import '../theming/colors.dart';

class SvgWidget extends StatelessWidget {
  const SvgWidget({super.key, required this.svgName});
  final String svgName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      width: 25.w,
      child: SvgPicture.asset(svgName.svgPath(), color: ColorsManager.primary),
    );
  }
}
