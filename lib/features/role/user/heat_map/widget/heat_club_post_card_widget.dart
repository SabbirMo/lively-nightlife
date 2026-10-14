import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/model/club_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_post_share_bottom_sheet.dart';

class HeatClubPostCardWidget extends StatelessWidget {
  final ClubPostModel post;

  const HeatClubPostCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),

      color: AppColors.whiteColor,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const AssetImage(
                    'assets/images/feedImage.png',
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextProperty(
                        text: 'luna_vibes',
                        textColor: AppColors.blackColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),

                      SizedBox(height: 2.h),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12.sp,
                            color: AppColors.greyColor,
                          ),

                          SizedBox(width: 2.w),

                          Expanded(
                            child: TextProperty(
                              text: 'Story Nightclub, Miami · ${post.time}',
                              textColor: AppColors.greyColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,

                      position: const RelativeRect.fromLTRB(100, 100, 20, 0),

                      items: [
                        const PopupMenuItem(
                          value: 'report',
                          child: Text('Report Post'),
                        ),

                        const PopupMenuItem(
                          value: 'copy',
                          child: Text('Copy Link'),
                        ),

                        const PopupMenuItem(
                          value: 'not_interested',
                          child: Text('Not Interested'),
                        ),
                      ],
                    );
                  },

                  child: SvgPicture.asset(IconPath.threeDotIcon),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          /// MEDIA
          SizedBox(
            width: double.infinity,

            child: AspectRatio(
              aspectRatio: 1,

              child: Stack(
                children: [
                  Image.asset(
                    post.mediaUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  if (post.isVideo)
                    Center(
                      child: Container(
                        width: 60.w,
                        height: 60.w,

                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .4),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 34.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.h),

          /// ACTIONS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),

            child: Row(
              children: [
                /// LIKE
                Obx(
                  () => Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          post.isLiked.toggle();

                          if (post.isLiked.value) {
                            post.likesCount.value++;
                          } else {
                            post.likesCount.value--;
                          }
                        },

                        child: SvgPicture.asset(
                          IconPath.likeIcon,

                          colorFilter: ColorFilter.mode(
                            post.isLiked.value
                                ? Colors.red
                                : AppColors.lightGreyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),

                        child: TextProperty(
                          text: '${post.likesCount.value}',
                          textColor: AppColors.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 18.w),

                /// SHARE
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => HeatPostShareBottomSheet(post: post),
                    );
                  },

                  child: SvgPicture.asset(IconPath.shareIcon),
                ),

                const Spacer(),

                /// SAVE
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      post.isSaved.toggle();
                    },

                    child: SvgPicture.asset(
                      IconPath.saveIcon,

                      colorFilter: ColorFilter.mode(
                        post.isSaved.value
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          /// LIKES
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16.w),

          //   child: TextProperty(
          //     text: '8.4k likes',
          //     textColor: AppColors.blackColor,
          //     fontSize: 13.sp,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          SizedBox(height: 8.h),

          /// EXPERIENCE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),

            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'luna_vibes ',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),

                  TextSpan(
                    text: post.caption,
                    style: TextStyle(
                      color: AppColors.grey700Color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void _showShareSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     builder: (context) {
//       return Container(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Share Post',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),

//             const SizedBox(height: 20),

//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Share To Profile'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.chat),
//               title: const Text('Send To Chat'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: const Icon(Icons.share),
//               title: const Text('Share Externally'),
//               onTap: () {
//                 Navigator.pop(context);

//                 // Share.share(post.caption);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
