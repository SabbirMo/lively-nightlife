import 'dart:async';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class OtpController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxString otp = ''.obs;
  final RxInt seconds = 45.obs;
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  String email = '';
  String role = 'user';
  String type = 'signup';

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = (args['email'] ?? '').toString();
      role = (args['role'] ?? 'user').toString();
      type = (args['type'] ?? 'signup').toString();
    }
    startTimer();
  }

  void updateOtp(String value) {
    otp.value = value.trim();
    hasError.value = false;
    errorMessage.value = '';
  }

  void startTimer() {
    seconds.value = 45;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value <= 0) {
        timer.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    if (seconds.value > 0 || isResending.value) return;

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email address not found. Please try registering again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isResending.value = true;
      final response = await _apiService.post(
        ApiEndpoints.resendOtp,
        data: {'email': email},
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        startTimer();
        Get.snackbar(
          'OTP Sent',
          'A new verification code has been sent to your email.',
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

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    if (otp.value.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Please enter the verification code.';
      return;
    }

    if (email.isEmpty) {
      hasError.value = true;
      errorMessage.value =
          'Email address not found. Please try registering again.';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp.value},
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Account verified successfully! Please log in.',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(
          AppRoute.loginView,
          arguments: {'email': email, 'role': role},
        );
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
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
