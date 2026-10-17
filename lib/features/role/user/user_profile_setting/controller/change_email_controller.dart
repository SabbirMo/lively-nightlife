import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/controller/user_profile_setting_controller.dart';

class ChangeEmailController extends GetxController {
  final ApiService _apiService = ApiService();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> changeEmail() async {
    final password = passwordController.text.trim();
    final newEmail = newEmailController.text.trim();

    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newEmail.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your new email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(newEmail)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.changeEmail,
        data: {
          'password': password,
          'new_email': newEmail,
        },
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        passwordController.clear();
        newEmailController.clear();

        // Refetch profile in background if UserProfileSettingController is alive
        if (Get.isRegistered<UserProfileSettingController>()) {
          Get.find<UserProfileSettingController>().fetchUserProfile();
        }

        Get.back();

        String message = 'Email changed successfully!';
        if (response.data is Map && response.data['message'] != null) {
          message = response.data['message'].toString();
        }

        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Change Email Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    newEmailController.dispose();
    super.onClose();
  }
}
