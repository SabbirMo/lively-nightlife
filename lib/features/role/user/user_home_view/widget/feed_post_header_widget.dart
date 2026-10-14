import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';

class FeedPostHeaderWidget extends StatelessWidget {
  final FeedPostModel post;

  const FeedPostHeaderWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.5),
              width: 2.w,
            ),
          ),
          child: CircleAvatar(
            radius: 18.r,
            backgroundImage: NetworkImage(post.profileImage),
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextProperty(
                    text: post.userName,
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),

                  SizedBox(width: 8.w),

                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        post.isFollowing.toggle();
                      },
                      child: TextProperty(
                        text: post.isFollowing.value ? 'Following' : 'Follow',
                        textColor: AppColors.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              TextProperty(
                text: '📍 ${post.location} • ${post.time}',
                textColor: AppColors.greyColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),

        PopupMenuButton<String>(
          color: AppColors.whiteColor,
          icon: SvgPicture.asset(IconPath.threeDotIcon, width: 20.w),
          onSelected: (value) {
            Get.snackbar('Action', value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'View Profile',
              child: Text('View Profile'),
            ),
            const PopupMenuItem(
              value: 'Not Interested',
              child: Text('Not Interested'),
            ),
            const PopupMenuItem(
              value: 'Report Post',
              child: Text('Report Post'),
            ),
          ],
        ),
      ],
    );
  }
}
