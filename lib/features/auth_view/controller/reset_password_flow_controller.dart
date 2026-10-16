import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/password_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class ResetPasswordFlowController extends GetxController {
  final ApiService _apiService = ApiService();

  final currentStep = 0.obs;
  final TextEditingController emailController = TextEditingController();
  List<TextEditingController?> otpControllers = [];
  String otpCode = '';
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  Timer? timer;
  final RxInt seconds = 0.obs;

  String? resetToken;

  String get currentOtp {
    if (otpControllers.isNotEmpty) {
      final code = otpControllers.map((c) => c?.text ?? '').join().trim();
      if (code.isNotEmpty) return code;
    }
    return otpCode.trim();
  }

  void startTimer() {
    seconds.value = 45;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value <= 0) {
        t.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    try {
      isResending.value = true;
      final response = await _apiService.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
        requireAuth: false,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        startTimer();
        Get.snackbar(
          'OTP Sent',
          'Verification code sent again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Resend Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isResending.value = false;
    }
  }

  static const int totalSteps = 3;

  Future<void> nextPage() async {
    if (currentStep.value == 0) {
      // Step 1: Request Password Reset OTP
      final email = emailController.text.trim();

      if (email.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter your email address',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (!GetUtils.isEmail(email)) {
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
          ApiEndpoints.forgotPassword,
          data: {'email': email},
          requireAuth: false,
        );

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          startTimer();
          currentStep.value = 1;
          Get.snackbar(
            'OTP Sent',
            'Password reset code has been sent to your email.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Request Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
      return;
    }

    if (currentStep.value == 1) {
      // Step 2: Verify OTP
      final email = emailController.text.trim();
      final code = currentOtp;

      if (code.length != 4) {
        hasError.value = true;
        errorMessage.value = 'Please enter the 4 digit code.';
        return;
      }

      otpCode = code;

      try {
        isLoading.value = true;
        hasError.value = false;
        errorMessage.value = '';

        final response = await _apiService.post(
          ApiEndpoints.passwordVerifyOtp,
          data: {'email': email, 'otp': code},
          requireAuth: false,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          String? token;
          if (response.data is Map<String, dynamic>) {
            final data = response.data['data'];
            if (data is Map<String, dynamic>) {
              token = data['token']?.toString();
            }
          }

          if (token != null && token.isNotEmpty) {
            resetToken = token;
            currentStep.value = 2;
            Get.snackbar(
              'Success',
              'Code verified! Please create a new password.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            hasError.value = true;
            errorMessage.value =
                'Verification token missing. Please try again.';
            Get.snackbar(
              'Verification Failed',
              'Invalid response from server. Reset token missing.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      } catch (e) {
        hasError.value = true;
        errorMessage.value = e.toString();
        Get.snackbar(
          'Verification Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
      return;
    }

    if (currentStep.value == 2) {
      // Step 3: Set New Password
      final passwordController = Get.find<PasswordController>(
        tag: 'createPassword',
      );
      final newPassword = passwordController.password.value;
      final confirmPassword = passwordController.confirmPassword.value;

      if (newPassword.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter a new password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (newPassword.length < 8) {
        Get.snackbar(
          'Validation Error',
          'Password must be at least 8 characters long',
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
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (resetToken == null || resetToken!.isEmpty) {
        Get.snackbar(
          'Session Expired',
          'Reset token is missing or expired. Please verify your OTP again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        currentStep.value = 1;
        return;
      }

      try {
        isLoading.value = true;

        final response = await _apiService.post(
          ApiEndpoints.resetPassword,
          data: {
            'email': emailController.text.trim(),
            'token': resetToken,
            'new_password': newPassword,
            'confirm_password': confirmPassword,
          },
          requireAuth: false,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          isLoading.value = false;
          Get.offAllNamed(AppRoute.loginView);
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.snackbar(
              'Success',
              'Password reset successfully. Please login with your new password.',
              snackPosition: SnackPosition.BOTTOM,
            );
          });
          return;
        }
      } catch (e) {
        Get.snackbar(
          'Reset Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
      return;
    }
  }

  void previousPage() {
    if (currentStep.value > 0) {
      currentStep.value--;
      hasError.value = false;
      errorMessage.value = '';
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}
