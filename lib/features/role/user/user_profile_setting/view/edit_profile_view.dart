import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: AppColors.blackColor,
          ),
        ),
        title: TextProperty(
          text: 'Edit Profile',
          textColor: AppColors.blackColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Sora',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Cover & Profile Photo Section
            _buildImagesHeader(context),

            SizedBox(height: 16.h),

            // Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username Field
                  _buildLabel('Username *'),
                  CustomTextfield(
                    controller: controller.usernameController,
                    fieldText: 'Enter username',
                    fillColor: const Color(0xFFF8FAFC),
                    borderColor: const Color(0xFFE2E8F0),
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 4.h),
                  TextProperty(
                    text:
                        'Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.',
                    textColor: AppColors.lightGreyColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 20.h),

                  // First Name Field
                  _buildLabel('First Name'),
                  CustomTextfield(
                    controller: controller.firstNameController,
                    fieldText: 'Enter first name',
                    fillColor: const Color(0xFFF8FAFC),
                    borderColor: const Color(0xFFE2E8F0),
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 20.h),

                  // Last Name Field
                  _buildLabel('Last Name'),
                  CustomTextfield(
                    controller: controller.lastNameController,
                    fieldText: 'Enter last name',
                    fillColor: const Color(0xFFF8FAFC),
                    borderColor: const Color(0xFFE2E8F0),
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 20.h),

                  // Date of Birth Field
                  _buildLabel('Date of Birth'),
                  GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: AbsorbPointer(
                      child: CustomTextfield(
                        controller: controller.dobController,
                        fieldText: 'YYYY-MM-DD',
                        fillColor: const Color(0xFFF8FAFC),
                        borderColor: const Color(0xFFE2E8F0),
                        borderRadius: 12.r,
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 20.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Location Field
                  _buildLabel('Location'),
                  CustomTextfield(
                    controller: controller.locationNameController,
                    fieldText: 'City, Country',
                    fillColor: const Color(0xFFF8FAFC),
                    borderColor: const Color(0xFFE2E8F0),
                    borderRadius: 12.r,
                    suffixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 20.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Bio Field
                  _buildLabel('Bio'),
                  TextField(
                    controller: controller.bioController,
                    maxLines: 4,
                    cursorColor: AppColors.blackColor,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: AppColors.blackColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tell everyone about yourself...',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        color: AppColors.lightGreyColor,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: EdgeInsets.all(14.r),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),

                  // Save Button
                  Obx(
                    () => CustomButton(
                      text: 'Save Changes',
                      isLoading: controller.isLoading.value,
                      borderRadius: BorderRadius.circular(100.r),
                      onTap: controller.updateProfile,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextProperty(
        text: label,
        textColor: AppColors.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Sora',
      ),
    );
  }

  Widget _buildImagesHeader(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover Image
          Obx(() {
            final file = controller.coverImage.value;
            final url = controller.existingCoverImageUrl.value;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.pickCoverImage(ImageSource.gallery),
              onLongPress: () => _showImagePickerSheet(
                context,
                onPick: controller.pickCoverImage,
              ),
              child: Container(
                width: double.infinity,
                height: 150.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  image: file != null
                      ? DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        )
                      : (url.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
                child: file == null && url.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 4.h),
                            TextProperty(
                              text: 'Add Cover Photo',
                              textColor: AppColors.greyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            );
          }),

          // Cover Camera Badge
          Positioned(
            right: 16.w,
            top: 104.h,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.pickCoverImage(ImageSource.gallery),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Profile Image Avatar
          Positioned(
            left: 20.w,
            top: 100.h,
            width: 96.w,
            height: 96.h,
            child: Obx(() {
              final file = controller.profileImage.value;
              final url = controller.existingProfileImageUrl.value;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.pickProfileImage(ImageSource.gallery),
                onLongPress: () => _showImagePickerSheet(
                  context,
                  onPick: controller.pickProfileImage,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 96.w,
                      height: 96.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 4.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: file != null
                            ? Image.file(
                                file,
                                fit: BoxFit.cover,
                              )
                            : (url.isNotEmpty
                                ? Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _defaultAvatar(),
                                  )
                                : _defaultAvatar()),
                      ),
                    ),

                    // Profile Camera Edit Badge
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: Center(
        child: Icon(
          Icons.person,
          size: 46.sp,
          color: AppColors.greyColor,
        ),
      ),
    );
  }

  void _showImagePickerSheet(
    BuildContext context, {
    required Function(ImageSource) onPick,
  }) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextProperty(
                text: 'Select Image Source',
                textColor: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Sora',
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primaryColor),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  onPick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primaryColor),
                title: const Text('Take a Photo'),
                onTap: () {
                  Get.back();
                  onPick(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
