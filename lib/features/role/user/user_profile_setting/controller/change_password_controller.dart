import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';

class ChangePasswordController extends GetxController {
  final ApiService _apiService = ApiService();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your old password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your new password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Validation Error',
        'New password must be at least 8 characters long',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please confirm your new password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Validation Error',
        'New password and confirmation password do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (oldPassword == newPassword) {
      Get.snackbar(
        'Validation Error',
        'New password cannot be the same as your old password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.back();

        String message = 'Password changed successfully!';
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
        'Change Password Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
