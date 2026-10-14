import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/share_bottom_Sheet_widget.dart';
import 'comment_section_widget.dart';

class FeedPostActionsWidget extends StatelessWidget {
  final FeedPostModel post;

  const FeedPostActionsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHomeController>();

    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.toggleLike(post);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.likeIcon,
                      width: 22.w,
                      colorFilter: ColorFilter.mode(
                        post.isLiked.value ? Colors.red : AppColors.greyColor,
                        BlendMode.srcIn,
                      ),
                    ),

                    SizedBox(width: 4.w),

                    TextProperty(
                      text: post.likeCount.value.toString(),
                      textColor: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 18.w),

              GestureDetector(
                onTap: () {
                  controller.toggleComments(post);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(IconPath.commentIcon, width: 22.w),

                    SizedBox(width: 4.w),

                    TextProperty(
                      text: post.commentCount.value.toString(),
                      textColor: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 18.w),

              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    ShareBottomSheetWidget(post: post),
                    backgroundColor: Colors.white,
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(IconPath.shareIcon, width: 22.w),

                    SizedBox(width: 4.w),

                    TextProperty(
                      text: post.shareCount.value.toString(),
                      textColor: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  controller.toggleSave(post);
                },
                child: SvgPicture.asset(
                  IconPath.saveIcon,
                  width: 22.w,
                  colorFilter: ColorFilter.mode(
                    post.isSaved.value
                        ? AppColors.primaryColor
                        : AppColors.greyColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),

          if (post.showComments.value)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: CommentSectionWidget(post: post, controller: controller),
            ),
        ],
      ),
    );
  }
}
