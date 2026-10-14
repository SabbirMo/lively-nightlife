import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final double? boxtHeight;
  final double? fontSize;
  final Color? fillColor;
  final double? iconHeight;
  final String hintText;
  final Color? iconColor;
  final String? prefixIcon;
  final bool showBorder;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final List<String>? suggestions;
  final Function(String)? onSuggestionTap;
  final bool showSuggestions;
  final double? borderRadius;
  final bool isShadowNeed;
  final Color? borderColor;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.boxtHeight,
    this.fillColor,
    this.prefixIcon,
    this.iconColor,
    this.fontSize,
    this.iconHeight,
    this.showBorder = true,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.suggestions,
    this.onSuggestionTap,
    this.showSuggestions = false,
    this.borderRadius,
    this.isShadowNeed = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: boxtHeight ?? 40.h,
          decoration: BoxDecoration(
            // boxShadow: isShadowNeed
            //     ? [
            //         BoxShadow(
            //           color: Colors.black.withAlpha(12),
            //           blurRadius: 10.6.r,
            //           offset: Offset(0, 0),
            //           spreadRadius: 0,
            //         ),
            //       ]
            //     : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.whiteColor,
              fontSize: fontSize ?? 16.sp,
            ),
            cursorColor: AppColors.whiteColor,
            cursorHeight: 16.h,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: fillColor ?? Colors.transparent,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.greyColor,
                fontSize: fontSize ?? 14.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 6.h,
              ),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: iconHeight ?? 14.w,
                        height: iconHeight ?? 14.h,
                        child: Image.asset(
                          prefixIcon!,
                          color: iconColor,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : null,

              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 40.h,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
                borderSide: showBorder
                    ? BorderSide(color: borderColor ?? AppColors.greyColor)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
                borderSide: showBorder
                    ? BorderSide(color: borderColor ?? AppColors.greyColor)
                    : BorderSide.none,
              ),
            ),
          ),
        ),
        if (showSuggestions && suggestions != null && suggestions!.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 8.h),
            decoration: BoxDecoration(
              color: fillColor ?? Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.greyColor),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withAlpha(25),
              //     blurRadius: 8.r,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            constraints: BoxConstraints(maxHeight: 200.h),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onSuggestionTap?.call(suggestions![index]),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      border: index != suggestions!.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: AppColors.defaultBorderColor.withAlpha(
                                  77,
                                ),
                              ),
                            )
                          : null,
                    ),
                    child: Text(
                      suggestions![index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: fontSize ?? 16.sp,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
