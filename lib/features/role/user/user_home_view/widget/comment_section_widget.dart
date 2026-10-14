import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';

class CommentSectionWidget extends StatelessWidget {
  final FeedPostModel post;
  final UserHomeController controller;

  const CommentSectionWidget({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...post.comments.map(
          (comment) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                CircleAvatar(radius: 12.r),

                SizedBox(width: 8.w),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${comment.userName} ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: comment.comment,
                          style: TextStyle(color: AppColors.greyColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                borderColor: AppColors.greyColor.withValues(alpha: 0.15),
                borderRadius: 100.r,
                controller: controller.commentController,
                fieldText: 'Add a comment...',
                fillColor: AppColors.grey100Color,
              ),
            ),

            SizedBox(width: 10.w),

            CustomButton(
              text: 'Post',
              textColor: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100.r),
              color: AppColors.blueColor.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
              onTap: () {
                controller.addComment(post, controller.commentController.text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
