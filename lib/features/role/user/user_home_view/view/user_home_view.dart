import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
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
                  child: Obx(() {
                    final isForYou = controller.selectedTab.value == 0;
                    final isFollowing = controller.selectedTab.value == 1;
                    final isNearby = controller.selectedTab.value == 2;

                    if (isForYou &&
                        controller.isLoadingForYou.value &&
                        controller.forYouPosts.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (isFollowing &&
                        controller.isLoadingFollowing.value &&
                        controller.followingPosts.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (isNearby &&
                        controller.isLoadingNearby.value &&
                        controller.nearbyPosts.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (controller.currentPosts.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primaryColor,
                        onRefresh: () async {
                          if (isForYou) {
                            await controller.fetchForYouPosts(isRefresh: true);
                          } else if (isFollowing) {
                            await controller.fetchFollowingPosts(isRefresh: true);
                          } else if (isNearby) {
                            await controller.fetchNearbyPosts(isRefresh: true);
                          }
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 100.h),
                            Icon(
                              Icons.feed_outlined,
                              size: 48.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 12.h),
                            Center(
                              child: TextProperty(
                                text: isFollowing
                                    ? 'No posts from people you follow yet'
                                    : 'No posts yet',
                                textColor: AppColors.greyColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final showLoadingMore =
                        (isForYou && controller.isLoadingMore.value) ||
                        (isFollowing && controller.isLoadingMoreFollowing.value) ||
                        (isNearby && controller.isLoadingMoreNearby.value);
                    final totalCount =
                        controller.currentPosts.length +
                        (showLoadingMore ? 1 : 0);

                    return RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        if (isForYou) {
                          await controller.fetchForYouPosts(isRefresh: true);
                        } else if (isFollowing) {
                          await controller.fetchFollowingPosts(isRefresh: true);
                        } else if (isNearby) {
                          await controller.fetchNearbyPosts(isRefresh: true);
                        }
                      },
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 120.h,
                        ),
                        itemCount: totalCount,
                        itemBuilder: (_, index) {
                          if (index == controller.currentPosts.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }

                          return FeedPostCardWidget(
                            post: controller.currentPosts[index],
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
