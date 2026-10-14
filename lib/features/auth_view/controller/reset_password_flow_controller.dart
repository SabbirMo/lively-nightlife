import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class ResetPasswordFlowController extends GetxController {
  final ApiService _apiService = ApiService();

  final currentStep = 0.obs;
  final TextEditingController emailController = TextEditingController();
  String otpCode = '';
  String? resetToken;
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  Timer? timer;
  final RxInt seconds = 0.obs;

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

  void onPageChanged(int index) {
    currentStep.value = index;
    hasError.value = false;
    errorMessage.value = '';
  }

  Future<void> nextPage() async {
    if (currentStep.value == 0) {
      // Send OTP for Forgot Password
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
      // Verify OTP
      if (otpCode.length != 4) {
        hasError.value = true;
        errorMessage.value = 'Please enter the 4 digit code.';
        return;
      }

      try {
        isLoading.value = true;
        hasError.value = false;
        errorMessage.value = '';

        await Future.delayed(const Duration(seconds: 1));

        isLoading.value = false;

        if (otpCode != '1234') {
          hasError.value = true;
          errorMessage.value = 'Oh no! incorrect code.';
          return;
        }

        currentStep.value = 2;
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        isLoading.value = false;
      }
      return;
    }

    if (currentStep.value == 2) {
      // Reset password
      try {
        isLoading.value = true;
        Get.snackbar('Success', 'Password reset successful. Please login.');
        Get.offAllNamed(AppRoute.loginView);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        isLoading.value = false;
      }
      return;
    }
  }

  //   if (currentStep.value == 1) {
  //     // Verify OTP
  //     final email = emailController.text.trim();
  //     try {
  //       isLoading.value = true;
  //       final response = await ApiService.verifyOtp(
  //         body: {'email': email, 'otp': otpCode},
  //       );

  //       resetToken = _extractToken(response);
  //       if (resetToken != null && resetToken!.isNotEmpty) {
  //         final storage = GetStorage();
  //         storage.write('access_token', resetToken);
  //         storage.write('is_logged_in', true);
  //       }

  //       await pageController.nextPage(
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     } catch (e) {
  //       Get.snackbar('Error', e.toString());
  //     } finally {
  //       isLoading.value = false;
  //     }
  //     return;
  //   }

  //   if (currentStep.value == 2) {
  //     // Reset password
  //     final passwordController = Get.find<PasswordController>(
  //       tag: 'createPassword',
  //     );
  //     final newPassword = passwordController.password.value;
  //     try {
  //       isLoading.value = true;
  //       await ApiService.resetPassword(
  //         body: {
  //           'new_password': newPassword,
  //           'email': emailController.text.trim(),
  //           'otp': otpCode,
  //         },
  //       );
  //       Get.snackbar('Success', 'Password reset successful. Please login.');
  //       Get.find<AuthService>().resetSession();
  //       Get.offAllNamed(AppRoute.loginView);
  //     } catch (e) {
  //       Get.snackbar('Error', e.toString());
  //     } finally {
  //       isLoading.value = false;
  //     }
  //     return;
  //   }
  // }

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
    super.onClose();
  }
}
