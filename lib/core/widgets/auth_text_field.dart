import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/styles.dart';

class AuthTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool? isObscureText;
  final bool? showCursor;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final int? maxLines;
  final bool? readOnly;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  const AuthTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.hintText,
    this.isObscureText,
    this.showCursor,
    this.keyboardType,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.onTap,
    this.maxLines,
    this.readOnly,
    this.enabled,
    this.onChanged,
    this.inputFormatters,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      maxLines: maxLines,
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar.editable(
              anchors: editableTextState.contextMenuAnchors,
              clipboardStatus: ClipboardStatus.pasteable,
              onCopy: () => editableTextState.copySelection(
                SelectionChangedCause.toolbar,
              ),
              onCut: () =>
                  editableTextState.cutSelection(SelectionChangedCause.toolbar),
              onPaste: () {
                editableTextState.pasteText(SelectionChangedCause.tap);
              },
              onSelectAll: () =>
                  editableTextState.selectAll(SelectionChangedCause.toolbar),
              onLookUp: null,
              onSearchWeb: null,
              onShare: null,
              onLiveTextInput: null,
            );
          },
      showCursor: showCursor,
      keyboardType: keyboardType,
      obscuringCharacter: '*',
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors
                .grey[500]!, //BorderSide(width: 1, color: Color(0xFF79747E))
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black.withOpacity(
                  0.15,
                ), //BorderSide(width: 1, color: Color(0xFF79747E))
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black.withOpacity(
                  0.15,
                ), //BorderSide(width: 1, color: Color(0xFF79747E))
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.w),
          borderRadius: BorderRadius.circular(4.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.w),
          borderRadius: BorderRadius.circular(4.r),
        ),
        hintStyle:
            hintStyle ??
            TextStyles.font12Black600.copyWith(
              color: Colors.black.withOpacity(0.42),
              fontWeight: FontWeight.w400,
            ),
        hintText: hintText ?? '',
        suffix: suffix,
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
        fillColor: backgroundColor ?? Colors.white,
        filled: true,
        prefixIconConstraints: BoxConstraints(minWidth: 16.w, minHeight: 17.h),
        prefixIcon: prefixIcon,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyles.font16Black500,
      textAlign: textAlign ?? TextAlign.start,
      validator: validator,
    );
  }
}
