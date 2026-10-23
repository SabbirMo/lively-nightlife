import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import '../model/user_lineup_model.dart';

class UserEventArtistCapsule extends StatelessWidget {
  final UserLineupModel artist;

  const UserEventArtistCapsule({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.grey50Color,
            backgroundImage: (artist.image.isNotEmpty &&
                    artist.image.startsWith('http'))
                ? NetworkImage(artist.image)
                : (artist.image.isNotEmpty &&
                        artist.image.startsWith('assets/'))
                    ? AssetImage(artist.image)
                    : null,
            child: (artist.image.isEmpty ||
                    (!artist.image.startsWith('http') &&
                        !artist.image.startsWith('assets/')))
                ? Icon(
                    Icons.person,
                    color: AppColors.greyColor,
                    size: 24.sp,
                  )
                : null,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: artist.name,
                  textColor: AppColors.blackColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 2.h),
                TextProperty(
                  text: artist.role,
                  textColor: AppColors.lightGreyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          SvgPicture.asset(IconPath.musicIcon, height: 16.h, width: 16.w),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
