import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_share_bottom_sheet.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/view/club_upload_content_view.dart';

class ClubContentTab extends StatelessWidget {
  const ClubContentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload Button
        CustomButton(
          iconImagePath: IconPath.addIcon,
          height: 14.h,
          text: 'Upload New Content',
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100.r),
          onTap: () => Get.to(() => const ClubUploadContentView()),
        ),
        SizedBox(height: 24.h),

        // 2x2 Grid Metrics
        Obx(
          () => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.60,
            children: [
              _buildMetricCard(
                Icons.image_outlined,
                controller.contentPostsCount.value,
                'Total Posts',
                AppColors.purpleColor,
              ),
              _buildMetricCard(
                Icons.visibility_outlined,
                controller.contentViewsCount.value,
                'Total Views',
                AppColors.insaneColor,
              ),
              _buildMetricCard(
                Icons.favorite_border,
                controller.contentLikesCount.value,
                'Total Likes',
                AppColors.hotColor,
              ),
              _buildMetricCard(
                Icons.share_outlined,
                controller.contentSharesCount.value,
                'Total Shares',
                AppColors.mildColor,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Section Title
        TextProperty(
          text: 'Your posts',
          textColor: AppColors.blackColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 16.h),

        // Posts List
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.contentPosts.length,
            separatorBuilder: (context, index) => SizedBox(height: 24.h),
            itemBuilder: (context, index) {
              final post = controller.contentPosts[index];
              return _buildPostCard(post, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    IconData icon,
    String value,
    String label,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 24.sp, color: iconColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextProperty(
                text: value,
                textColor: AppColors.blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 4.h),
              TextProperty(
                text: label,
                textColor: AppColors.lightGreyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(FeedPostModel post, ClubHomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: NetworkImage(post.profileImage),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: post.userName,
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 2.h),
                  TextProperty(
                    text: '📍 ${post.location} • ${post.time}',
                    textColor: AppColors.lightGreyColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: AppColors.whiteColor,
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.lightGreyColor,
              ),
              onSelected: (value) {
                Get.snackbar('Post Option Selected', value);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Edit Post',
                  child: Text('Edit Post'),
                ),
                const PopupMenuItem(
                  value: 'Delete Post',
                  child: Text('Delete Post'),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Post Image
        // Post Image(s)
        _buildPostImages(post),
        SizedBox(height: 12.h),

        // Actions Row
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleLike(post),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.likeIcon,
                          width: 22.w,
                          colorFilter: ColorFilter.mode(
                            post.isLiked.value
                                ? Colors.red
                                : AppColors.lightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        TextProperty(
                          text: post.likeCount.value.toString(),
                          textColor: AppColors.lightGreyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 18.w),
                  GestureDetector(
                    onTap: () => controller.toggleComments(post),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.commentIcon,
                          width: 22.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.lightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        TextProperty(
                          text: post.commentCount.value.toString(),
                          textColor: AppColors.lightGreyColor,
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
                        ClubShareBottomSheet(post: post),
                        backgroundColor: Colors.white,
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.shareIcon,
                          width: 22.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.lightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        TextProperty(
                          text: post.shareCount.value.toString(),
                          textColor: AppColors.lightGreyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Caption
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${post.userName} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: post.caption,
                      style: TextStyle(
                        color: AppColors.secondBlackColor,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),

              // Hashtags
              TextProperty(
                text: post.hashtags,
                textColor: AppColors.blueColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),

              // Expandable Comments Section
              if (post.showComments.value)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildCommentSection(post, controller),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(
    FeedPostModel post,
    ClubHomeController controller,
  ) {
    return Column(
      children: [
        ...post.comments.map(
          (comment) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12.r,
                  backgroundColor: AppColors.grey50Color,
                  child: const Icon(
                    Icons.person,
                    size: 12,
                    color: AppColors.lightGreyColor,
                  ),
                ),
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
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: comment.comment,
                          style: TextStyle(
                            color: AppColors.lightGreyColor,
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                          ),
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
                borderColor: AppColors.lightGreyColor.withValues(alpha: 0.15),
                borderRadius: 100.r,
                controller: controller.commentController,
                fieldText: 'Add a comment...',
                fillColor: AppColors.lightGreyColor2,
              ),
            ),
            SizedBox(width: 10.w),
            CustomButton(
              text: 'Post',
              textColor: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100.r),
              color: AppColors.primaryColor,
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

  Widget _buildPostImages(FeedPostModel post) {
    final List<String> images = post.images != null && post.images!.isNotEmpty
        ? post.images!
        : [post.image];

    if (images.length == 1) {
      final imagePath = images.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: imagePath.startsWith('assets/')
            ? Image.asset(
                imagePath,
                width: double.infinity,
                height: 260.h,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(imagePath),
                width: double.infinity,
                height: 260.h,
                fit: BoxFit.cover,
              ),
      );
    }

    final activeIndex = 0.obs;
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) => activeIndex.value = index,
              itemBuilder: (context, index) {
                final imagePath = images[index];
                return imagePath.startsWith('assets/')
                    ? Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 260.h,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath),
                        width: double.infinity,
                        height: 260.h,
                        fit: BoxFit.cover,
                      );
              },
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Obx(() => TextProperty(
                    text: '${activeIndex.value + 1}/${images.length}',
                    textColor: AppColors.whiteColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

