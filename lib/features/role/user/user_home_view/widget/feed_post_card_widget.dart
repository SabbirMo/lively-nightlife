import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/feed_post_action_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/feed_post_header_widget.dart';

class FeedPostCardWidget extends StatelessWidget {
  final FeedPostModel post;

  const FeedPostCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FeedPostHeaderWidget(post: post),
          ),

          SizedBox(height: 12.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.asset(
              post.image,
              width: double.infinity,
              height: 0.5.sh,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeedPostActionsWidget(post: post),

                SizedBox(height: 12.h),

                TextProperty(
                  text: post.caption,
                  textColor: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),

                SizedBox(height: 8.h),

                TextProperty(
                  text: post.hashtags,
                  textColor: AppColors.blueColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
