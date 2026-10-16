import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/controller/user_profile_setting_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/controller/user_profile_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/model/user_profile_model.dart';

class EditProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();

  // Selected Image Files
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<File?> coverImage = Rx<File?>(null);

  // Existing remote URLs
  final RxString existingProfileImageUrl = ''.obs;
  final RxString existingCoverImageUrl = ''.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentProfile();
  }

  String _resolveUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final base = ApiEndpoints.baseUrl.endsWith('/')
        ? ApiEndpoints.baseUrl.substring(0, ApiEndpoints.baseUrl.length - 1)
        : ApiEndpoints.baseUrl;
    final path = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$base$path';
  }

  void _loadCurrentProfile() async {
    try {
      UserProfileModel? profile;
      if (Get.isRegistered<UserProfileSettingController>()) {
        profile = Get.find<UserProfileSettingController>().userProfile.value;
      }
      if (profile == null && Get.isRegistered<UserProfileController>()) {
        profile = Get.find<UserProfileController>().userProfile.value;
      }
      if (profile == null && Get.isRegistered<UserHomeController>()) {
        profile = Get.find<UserHomeController>().userProfile.value;
      }

      if (profile != null) {
        _populateFields(profile);
      } else {
        await _fetchAndPopulate();
      }
    } catch (_) {}
  }

  void _populateFields(UserProfileModel profile) {
    usernameController.text = profile.username ?? '';
    firstNameController.text = profile.firstName ?? '';
    lastNameController.text = profile.lastName ?? '';
    dobController.text = profile.dob ?? '';
    bioController.text = profile.bio ?? '';
    locationNameController.text = profile.locationName ?? '';
    existingProfileImageUrl.value = _resolveUrl(profile.profileImage);
    existingCoverImageUrl.value = _resolveUrl(profile.coverImage);
  }

  Future<void> _fetchAndPopulate() async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.userProfile,
        requireAuth: true,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final profile = UserProfileModel.fromJson(response.data);
          _populateFields(profile);
        }
      }
    } catch (_) {}
  }

  Future<void> pickProfileImage([ImageSource source = ImageSource.gallery]) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file != null) {
        profileImage.value = File(file.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickCoverImage([ImageSource source = ImageSource.gallery]) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (file != null) {
        coverImage.value = File(file.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (dobController.text.trim().isNotEmpty) {
      try {
        initialDate = DateTime.parse(dobController.text.trim());
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> updateProfile() async {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      Get.snackbar('Validation Error', 'Username is required.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (username.length > 150) {
      Get.snackbar(
          'Validation Error', 'Username must be 150 characters or fewer.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final validPattern = RegExp(r'^[\w.@+-]+$');
    if (!validPattern.hasMatch(username)) {
      Get.snackbar(
        'Validation Error',
        'Username can only contain letters, digits, and @/./+/-/_.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> formMap = {
        'username': username,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'dob': dobController.text.trim(),
        'bio': bioController.text.trim(),
        'location_name': locationNameController.text.trim(),
      };

      if (profileImage.value != null) {
        formMap['profile_image'] = await MultipartFile.fromFile(
          profileImage.value!.path,
          filename: profileImage.value!.path.split('/').last,
        );
      }

      if (coverImage.value != null) {
        formMap['cover_image'] = await MultipartFile.fromFile(
          coverImage.value!.path,
          filename: coverImage.value!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiService.patch(
        ApiEndpoints.userProfile,
        data: formData,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final updatedProfile = UserProfileModel.fromJson(response.data);
          if (Get.isRegistered<UserProfileSettingController>()) {
            Get.find<UserProfileSettingController>().userProfile.value = updatedProfile;
          }
          if (Get.isRegistered<UserProfileController>()) {
            Get.find<UserProfileController>().userProfile.value = updatedProfile;
          }
          if (Get.isRegistered<UserHomeController>()) {
            Get.find<UserHomeController>().userProfile.value = updatedProfile;
          }
        }

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    bioController.dispose();
    locationNameController.dispose();
    super.onClose();
  }
}
