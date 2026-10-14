import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/feed_post_card_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/home_header_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/home_tab_widget.dart';

class UserHomeView extends GetView<UserHomeController> {
  const UserHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),

                      const HomeHeaderWidget(),

                      SizedBox(height: 30.h),

                      const HomeTabWidget(),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        bottom: 120.h,
                      ),
                      itemCount: controller.currentPosts.length,
                      itemBuilder: (_, index) => FeedPostCardWidget(
                        post: controller.currentPosts[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
