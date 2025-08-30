import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app_valu/core/theming/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;
  final bool isSearching;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.showClearButton = true,
    this.isSearching = false,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: TextField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: textColor ?? ColorsManager.textPrimary,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor ?? ColorsManager.textSecondary,
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: hintColor ?? ColorsManager.textSecondary,
            size: 24.w,
          ),
          suffixIcon: _buildSuffixIcon(),
          filled: true,
          fillColor: backgroundColor ?? ColorsManager.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: borderColor ?? ColorsManager.primary,
              width: 1.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!showClearButton) return null;

    if (isSearching) {
      return Padding(
        padding: EdgeInsets.all(8.w),
        child: SizedBox(
          width: 16.w,
          height: 16.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              hintColor ?? ColorsManager.textSecondary,
            ),
          ),
        ),
      );
    }

    if (controller.text.isNotEmpty) {
      return IconButton(
        onPressed: onClear ?? () => controller.clear(),
        icon: Icon(
          Icons.clear,
          color: hintColor ?? ColorsManager.textSecondary,
          size: 20.w,
        ),
      );
    }

    return null;
  }
}
