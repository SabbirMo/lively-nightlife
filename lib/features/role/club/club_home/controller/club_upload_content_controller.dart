import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';

class ClubUploadContentController extends GetxController {
  final RxInt currentStep = 1.obs;

  // Step 1 state
  final captionController = TextEditingController();
  final RxString selectedMood = ''.obs;
  final RxInt captionLength = 0.obs;
  final List<String> moods = ['🔥', '💜', '🎉', '🎧', '✨', '🌙', '💃', '🕺', '🍾', '🎀'];
  final RxList<String> selectedImagePaths = <String>[].obs;

  // Step 2 state
  final locationController = TextEditingController();
  final tagController = TextEditingController();
  final RxList<String> selectedTags = <String>[].obs;
  final List<String> tagSuggestions = [
    'EDM', 'Nightlife', 'Vegas', 'Miami', 'LA', 'Party', 'Club', 'Rave'
  ];
  final RxString visibility = 'Public'.obs;
  final RxList<String> taggedPeople = <String>[].obs;

  // Demo followers
  final List<Map<String, String>> demoFollowers = [
    {'name': 'luna_vibes', 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'party_queen', 'avatar': 'https://i.pravatar.cc/150?img=2'},
    {'name': 'dj_alex', 'avatar': 'https://i.pravatar.cc/150?img=3'},
    {'name': 'nightlife_88', 'avatar': 'https://i.pravatar.cc/150?img=4'},
    {'name': 'miami_vibes', 'avatar': 'https://i.pravatar.cc/150?img=5'},
    {'name': 'club_fanatic', 'avatar': 'https://i.pravatar.cc/150?img=6'},
  ];

  @override
  void onInit() {
    super.onInit();
    captionController.addListener(() {
      captionLength.value = captionController.text.length;
    });
  }

  @override
  void onClose() {
    captionController.dispose();
    locationController.dispose();
    tagController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImagePaths.assignAll(images.map((img) => img.path).toList());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  void nextStep() {
    if (currentStep.value == 1 && selectedImagePaths.isEmpty) {
      Get.snackbar(
        'Image Required',
        'Please select at least one image to upload.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  void addCustomTag() {
    final text = tagController.text.trim();
    if (text.isNotEmpty) {
      if (selectedTags.contains(text)) {
        Get.snackbar('Duplicate Tag', 'This tag is already added');
      } else if (selectedTags.length >= 10) {
        Get.snackbar('Limit Reached', 'You can add up to 10 tags');
      } else {
        selectedTags.add(text);
        tagController.clear();
      }
    }
  }

  void toggleSuggestedTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      if (selectedTags.length < 10) {
        selectedTags.add(tag);
      } else {
        Get.snackbar('Limit Reached', 'You can add up to 10 tags');
      }
    }
  }

  void showTagPeopleDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextProperty(
                text: 'Tag People',
                textColor: AppColors.secondBlackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 12.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: demoFollowers.length,
                  itemBuilder: (context, index) {
                    final follower = demoFollowers[index];
                    final name = follower['name']!;
                    final avatar = follower['avatar']!;
                    return Obx(() {
                      final isTagged = taggedPeople.contains(name);
                      return CheckboxListTile(
                        value: isTagged,
                        activeColor: AppColors.blueColor,
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 16.r,
                              backgroundImage: NetworkImage(avatar),
                            ),
                            SizedBox(width: 8.w),
                            TextProperty(
                              text: name,
                              textColor: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        onChanged: (val) {
                          if (val == true) {
                            taggedPeople.add(name);
                          } else {
                            taggedPeople.remove(name);
                          }
                        },
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: TextProperty(
                      text: 'Done',
                      textColor: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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

  void publishPost() {
    if (selectedImagePaths.isEmpty) return;
    final homeController = Get.find<ClubHomeController>();
    final newPost = FeedPostModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userName: 'alex_nights',
      profileImage: 'https://i.pravatar.cc/150?img=60',
      location: locationController.text.isNotEmpty
          ? locationController.text.trim()
          : 'Miami, FL',
      time: 'Just now',
      image: selectedImagePaths.first,
      images: selectedImagePaths.toList(),
      caption: captionController.text.trim(),
      hashtags: selectedTags.map((tag) => '#$tag').join(' '),
      isLiked: false,
      isSaved: false,
      isFollowing: false,
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      comments: [],
    );

    homeController.addPost(newPost);
    Get.back();
    Get.snackbar(
      'Success',
      'Post published successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.greenColor.withValues(alpha: 0.9),
      colorText: AppColors.whiteColor,
    );
  }
}
