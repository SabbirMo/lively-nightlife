import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/comment_model.dart';
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
        Obx(
          () => Column(
            children: post.comments.map((comment) {
              final hasPic =
                  comment.profileImage != null &&
                  comment.profileImage!.isNotEmpty &&
                  (comment.profileImage!.startsWith('http://') ||
                      comment.profileImage!.startsWith('https://'));
              final isMine = controller.isMyComment(comment);

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: AppColors.blueColor.withValues(
                        alpha: 0.1,
                      ),
                      backgroundImage: hasPic
                          ? NetworkImage(comment.profileImage!)
                          : null,
                      child: !hasPic
                          ? Text(
                              comment.userName.isNotEmpty
                                  ? comment.userName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : null,
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
                                fontSize: 13.sp,
                              ),
                            ),
                            TextSpan(
                              text: comment.comment,
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (comment.time.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Text(
                        comment.time,
                        style: TextStyle(
                          color: AppColors.lightGreyColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],

                    SizedBox(width: 2.w),
                    SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 16.sp,
                            color: AppColors.lightGreyColor,
                          ),
                          padding: EdgeInsets.zero,
                          tooltip: 'Options',
                          elevation: 6,
                          shadowColor: Colors.black.withValues(alpha: 0.2),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: AppColors.greyColor.withValues(
                                alpha: 0.15,
                              ),
                              width: 1,
                            ),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditCommentDialog(comment);
                            } else if (value == 'delete') {
                              _showDeleteConfirmDialog(comment);
                            } else if (value == 'report') {
                              _showReportCommentDialog(comment);
                            }
                          },
                          itemBuilder: (BuildContext ctx) => isMine
                              ? [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    height: 38.h,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 16.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(height: 1),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    height: 38.h,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          size: 16.sp,
                                          color: AppColors.redColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              : [
                                  PopupMenuItem<String>(
                                    value: 'report',
                                    height: 38.h,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.flag_outlined,
                                          size: 16.sp,
                                          color: AppColors.redColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Report',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(height: 1),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    height: 38.h,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          size: 16.sp,
                                          color: AppColors.redColor,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.redColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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

            Obx(
              () => CustomButton(
                text: 'Post',
                textColor: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(100.r),
                color: AppColors.blueColor,
                isLoading: post.isPostingComment.value,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
                onTap: () {
                  controller.addComment(
                    post,
                    controller.commentController.text,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditCommentDialog(CommentModel comment) {
    final editController = TextEditingController(text: comment.comment);
    final isUpdating = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Comment',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: editController,
                maxLines: 3,
                minLines: 1,
                autofocus: true,
                style: TextStyle(fontSize: 14.sp, color: AppColors.blackColor),
                decoration: InputDecoration(
                  hintText: 'Edit your comment...',
                  filled: true,
                  fillColor: AppColors.grey100Color,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.greyColor.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.greyColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => SizedBox(
                      height: 38.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                        ),
                        onPressed: isUpdating.value
                            ? null
                            : () async {
                                final newText = editController.text.trim();
                                if (newText.isEmpty ||
                                    newText == comment.comment) {
                                  Get.back();
                                  return;
                                }
                                isUpdating.value = true;
                                await controller.updateComment(
                                  post,
                                  comment,
                                  newText,
                                );
                                isUpdating.value = false;
                                Get.back();
                              },
                        child: isUpdating.value
                            ? SizedBox(
                                width: 16.h,
                                height: 16.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(CommentModel comment) {
    final isDeleting = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Comment',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Are you sure you want to delete this comment?',
                style: TextStyle(fontSize: 13.sp, color: AppColors.greyColor),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => SizedBox(
                      height: 38.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                        ),
                        onPressed: isDeleting.value
                            ? null
                            : () async {
                                isDeleting.value = true;
                                await controller.deleteComment(post, comment);
                                isDeleting.value = false;
                                Get.back();
                              },
                        child: isDeleting.value
                            ? SizedBox(
                                width: 16.h,
                                height: 16.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportCommentDialog(CommentModel comment) {
    final reasons = [
      'Inappropriate Content',
      'Spam or Scam',
      'Harassment or Hate',
      'Misinformation',
      'Other',
    ];
    final selectedReason = reasons.first.obs;
    final descriptionController = TextEditingController();
    final isSubmitting = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      color: AppColors.redColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Report Comment',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'Please select a reason and describe the issue.',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.greyColor),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Reason',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey100Color,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedReason.value,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: reasons
                            .map(
                              (r) => DropdownMenuItem<String>(
                                value: r,
                                child: Text(
                                  r,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) selectedReason.value = val;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 6.h),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.blackColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Provide details about this report...',
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.lightGreyColor,
                    ),
                    filled: true,
                    fillColor: AppColors.grey100Color,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(
                      () => SizedBox(
                        height: 38.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                          ),
                          onPressed: isSubmitting.value
                              ? null
                              : () async {
                                  isSubmitting.value = true;
                                  final desc = descriptionController.text
                                      .trim();
                                  await controller.reportComment(
                                    comment,
                                    reason: selectedReason.value,
                                    description: desc.isNotEmpty
                                        ? desc
                                        : selectedReason.value,
                                  );
                                  isSubmitting.value = false;
                                  Get.back();
                                },
                          child: isSubmitting.value
                              ? SizedBox(
                                  width: 16.h,
                                  height: 16.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Report',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
