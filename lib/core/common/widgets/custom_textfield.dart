import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class CustomTextfield extends StatelessWidget {
  final Color? fillColor;
  final String fieldText;
  final Color? borderColor;
  final bool isPassword;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int maxLines;
  final Color? hintTextColor;
  final double? borderRadius;
  final TextInputType? keyboardType;

  const CustomTextfield({
    super.key,
    this.fillColor,
    required this.fieldText,
    this.borderColor,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.hintTextColor,
    this.borderRadius,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isObscure = isPassword.obs;

    return Obx(() {
      return TextField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        controller: controller,
        onChanged: onChanged,
        obscureText: isObscure.value,
        cursorColor: AppColors.blackColor,
        cursorHeight: 20.h,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.blackColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fillColor ?? AppColors.whiteColor,

          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 14.w,
          ),

          hintText: fieldText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: hintTextColor ?? AppColors.lightGreyColor,
          ),

          // Prefix Icon
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 8.w),
                  child: SvgPicture.asset(
                    prefixIcon!,
                    height: 18.h,
                    width: 18.w,
                    // fit: BoxFit.contain,
                  ),
                )
              : null,

          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 40.h,
          ),

          // Suffix Icon
          suffixIcon: isPassword
              ? SizedBox(
                  width: 40.w,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => isObscure.value = !isObscure.value,
                      child: Icon(
                        isObscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                )
              : suffixIcon != null
              ? SizedBox(
                  width: 40.w,
                  child: Center(child: suffixIcon),
                )
              : null,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? Colors.transparent),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
            borderSide: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
      );
    });
  }
}
