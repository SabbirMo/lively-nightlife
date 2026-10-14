import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final Color? imageColor;
  final BorderRadius? borderRadius;
  final Color? iconColor;
  final IconData? icon;
  final Color? borderColor;
  final String text;
  final String? iconImagePath;
  final Color? color;
  final Color? textColor;
  final VoidCallback onTap;
  final double? fontSize;
  final double? width;
  final double? height;
  final double? iconSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final String? prefixIcon;
  final String? fontFamily;
  final String? rightIconPath;
  final bool? isShadowNeed;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final bool isLoading;

  const CustomButton({
    this.imageColor,
    this.borderRadius,
    this.iconColor,
    super.key,
    required this.text,
    required this.onTap,
    this.iconImagePath,
    this.color,
    this.textColor,
    this.fontSize,
    this.borderColor,
    this.icon,
    this.width,
    this.height,
    this.iconSize,
    this.buttonHeight,
    this.buttonWidth,
    this.prefixIcon,
    this.fontFamily,
    this.isShadowNeed = false,
    this.padding,
    this.fontWeight,
    this.rightIconPath,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        color: color ?? AppColors.primaryColor,
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: buttonWidth,
          // height: 40.h,
          padding:
              padding ??
              EdgeInsets.only(top: 14.h, bottom: 14.h, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  borderColor ?? AppColors.whiteColor.withValues(alpha: 0.12),
              width: 1.5.w,
            ),
            boxShadow: isShadowNeed == true
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withAlpha(76),
                      blurRadius: 12.r,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
            borderRadius: borderRadius ?? BorderRadius.circular(16.r),
            color: color ?? AppColors.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
              else ...[
                if (icon != null)
                  Icon(
                    icon,
                    size: iconSize ?? 18.sp,
                    color: iconColor ?? Colors.white,
                  ),
                if (icon != null) SizedBox(width: 8.h),
                if (iconImagePath != null)
                  SvgPicture.asset(
                    iconImagePath!,
                    height: height,
                    width: width,
                    colorFilter: imageColor != null
                        ? ColorFilter.mode(imageColor!, BlendMode.srcIn)
                        : null,
                  ),
                if (iconImagePath != null) SizedBox(width: 8.h),

                // ignore: unnecessary_null_comparison
                if (text != null)
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: fontFamily ?? 'Poppins',
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? 14.sp,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                if (rightIconPath != null)
                  Row(
                    children: [
                      SizedBox(width: 8.w),
                      SvgPicture.asset(
                        rightIconPath!,
                        width: iconSize,
                        height: iconSize,
                        colorFilter: iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
