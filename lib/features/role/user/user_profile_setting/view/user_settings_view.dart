import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_profile_setting_controller.dart';

class UserSettingsView extends GetView<UserProfileSettingController> {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller if not found
    final controller = Get.put(UserProfileSettingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Faded Top Blue Background Highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDCE9FE).withValues(alpha: 0.6),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Back + Title)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 22.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      TextProperty(
                        text: 'Settings',
                        textColor: AppColors.blackColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Sora',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchUserProfile,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Card
                          _buildProfileCard(controller),
                          SizedBox(height: 24.h),

                          // Account Section Header
                          _buildSectionHeader('ACCOUNT'),
                          SizedBox(height: 8.h),

                          // Account Actions Card
                          _buildAccountCard(context, controller),
                          SizedBox(height: 24.h),

                          // Support Section Header
                          _buildSectionHeader('SUPPORT'),
                          SizedBox(height: 8.h),

                          // Support Actions Card
                          _buildSupportCard(),
                          SizedBox(height: 24.h),

                          // Log Out Card
                          _buildLogOutButton(controller),
                          SizedBox(height: 32.h),

                          // Delete Account Card
                          _buildDeleteAccountButton(controller),
                          SizedBox(height: 40.h),
                        ],
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

  Widget _buildProfileCard(UserProfileSettingController controller) {
    return Obx(() {
      final isLoading = controller.isLoadingProfile.value;
      final imageUrl = controller.profileImageUrl;
      final displayName = isLoading ? 'Loading...' : controller.name;
      final username = isLoading ? '' : controller.username;
      final initial = displayName.isNotEmpty
          ? displayName[0].toUpperCase()
          : 'U';

      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Photo
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: const Color(0xFFF1F5F9),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 64.w,
                        height: 64.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: TextProperty(
                              text: initial,
                              textColor: AppColors.primaryColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Sora',
                            ),
                          );
                        },
                      )
                    : Center(
                        child: TextProperty(
                          text: initial,
                          textColor: AppColors.primaryColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Sora',
                        ),
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            // Name and Tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: displayName,
                    textColor: AppColors.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Sora',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  TextProperty(
                    text: username,
                    textColor: AppColors.lightGreyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Edit Pencil Icon
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.editProfileView);
              },
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.lightGreyColor,
                size: 22.sp,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TextProperty(
        text: title,
        textColor: AppColors.lightGreyColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    UserProfileSettingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Switch to Club
          _buildSettingsTile(
            icon: Icons.swap_horiz,
            iconColor: const Color(0xFF3B82F6),
            backgroundColor: const Color(0xFFEFF6FF),
            title: 'Switch to Club',
            onTap: () => controller.switchRoleToClub(),
          ),
          _buildDivider(),
          // Account Settings
          _buildSettingsTile(
            icon: Icons.person_outline,
            iconColor: const Color(0xFF8B5CF6),
            backgroundColor: const Color(0xFFF5F3FF),
            title: 'Account',
            onTap: () => Get.toNamed(AppRoute.userAccountSettingsView),
          ),
          _buildDivider(),
          // Notifications Settings
          _buildSettingsTile(
            icon: Icons.notifications_none_outlined,
            iconColor: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFFFFFBEB),
            title: 'Notifications',
            onTap: () => Get.toNamed(AppRoute.userNotificationsSettingsView),
          ),
          _buildDivider(),
          // Privacy & Safety Settings
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF10B981),
            backgroundColor: const Color(0xFFECFDF5),
            title: 'Privacy & Safety',
            onTap: () => Get.toNamed(AppRoute.userPrivacySettingsView),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Billing & Payments
          _buildSettingsTile(
            icon: Icons.credit_card,
            iconColor: const Color(0xFF10B981),
            backgroundColor: const Color(0xFFECFDF5),
            title: 'Billing & Payments',
            onTap: () {
              Get.snackbar(
                'Billing & Payments',
                'Billing details coming soon!',
              );
            },
          ),
          _buildDivider(),
          // Help & Support
          _buildSettingsTile(
            icon: Icons.help_outline,
            iconColor: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFFFFFBEB),
            title: 'Help & Support',
            onTap: () {
              Get.snackbar(
                'Help & Support',
                'Help and documentation coming soon!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            // Title
            Expanded(
              child: TextProperty(
                text: title,
                textColor: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right,
              color: AppColors.lightGreyColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: const Color(0xFFF8FAFC),
      indent: 16.w,
      endIndent: 16.w,
    );
  }

  Widget _buildLogOutButton(UserProfileSettingController controller) {
    return InkWell(
      onTap: () {
        _showLogoutDialog(onConfirm: () => controller.logout());
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFFECDD3), width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_outlined, color: AppColors.redColor, size: 20.sp),
            SizedBox(width: 8.w),
            TextProperty(
              text: 'Log Out',
              textColor: AppColors.redColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(UserProfileSettingController controller) {
    return GestureDetector(
      onTap: () {
        controller.deleteAccount();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, color: AppColors.redColor, size: 20.sp),
          SizedBox(width: 8.w),
          TextProperty(
            text: 'Delete Account',
            textColor: AppColors.redColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog({required VoidCallback onConfirm}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.redColor,
                  size: 26.sp,
                ),
              ),
              SizedBox(height: 16.h),
              TextProperty(
                text: 'Log Out',
                textColor: AppColors.blackColor,
                fontFamily: 'Sora',
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 8.h),
              TextProperty(
                text: 'Are you sure you want to log out?',
                textColor: AppColors.lightGreyColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                            width: 1.2.w,
                          ),
                        ),
                        child: TextProperty(
                          text: 'Cancel',
                          textColor: AppColors.secondBlackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        onConfirm();
                      },
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        height: 46.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(100.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.redColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextProperty(
                          text: 'Log Out',
                          textColor: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
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
}
