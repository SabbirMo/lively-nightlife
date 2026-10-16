import 'package:dio/dio.dart' show FormData;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get_storage/get_storage.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/models/auth_role.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<AuthRole> selectedRole = AuthRole.user.obs;

  final RxBool isLoading = false.obs;
  final rememberMe = false.obs;

  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';

  // Login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // User Signup
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();

  // Club Signup
  final clubNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Shared
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    try {
      final storage = GetStorage();
      final bool isRemembered = storage.read<bool>(_rememberMeKey) ?? false;
      if (isRemembered) {
        rememberMe.value = true;
        final savedEmail = storage.read<String>(_savedEmailKey);
        if (savedEmail != null && savedEmail.isNotEmpty) {
          emailController.text = savedEmail;
        }
      }
    } catch (_) {}
  }

  void changeRole(AuthRole role) {
    selectedRole.value = role;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

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

    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        String? access;
        String? refresh;

        if (data is Map<String, dynamic>) {
          access = data['access'] ?? data['access_token'] ?? data['token'];
          refresh = data['refresh'] ?? data['refresh_token'];

          if (access != null && access.isNotEmpty) {
            await TokenStorageService.saveTokens(
              accessToken: access,
              refreshToken: refresh,
            );
          }
        }

        // Handle remember me
        final storage = GetStorage();
        if (rememberMe.value) {
          await storage.write(_rememberMeKey, true);
          await storage.write(_savedEmailKey, email);
        } else {
          await storage.remove(_rememberMeKey);
          await storage.remove(_savedEmailKey);
        }

        Get.snackbar(
          'Success',
          'Logged in successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Check user role from response or decoded JWT payload or selectedRole
        String? activeProfile;
        if (data is Map<String, dynamic>) {
          activeProfile =
              data['active_profile'] ??
              data['role'] ??
              data['user']?['active_profile'] ??
              data['user']?['role'];
        }

        if (activeProfile == null && access != null) {
          final payload = TokenStorageService.decodeJwt(access);
          activeProfile = payload?['active_profile']?.toString();
        }

        final bool isVenue =
            activeProfile == 'venue' ||
            (activeProfile == null && selectedRole.value == AuthRole.club);

        if (isVenue) {
          selectedRole.value = AuthRole.club;
          Get.offAllNamed(AppRoute.clubBottomNavbarView);
        } else {
          selectedRole.value = AuthRole.user;
          Get.offAllNamed(AppRoute.userBottomNavigationBarView);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register API Call
  Future<void> register() async {
    if (isLoading.value) return;

    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your email address');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Validation Error', 'Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a password');
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('Validation Error', 'Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Validation Error', 'Passwords do not match');
      return;
    }

    // Determine registration type (user: Regular User, venue: Venue Account)
    final String registrationType = selectedRole.value == AuthRole.club
        ? 'venue'
        : 'user';

    String firstName = '';
    String lastName = '';
    String? dob;

    if (selectedRole.value == AuthRole.user) {
      firstName = firstNameController.text.trim();
      lastName = lastNameController.text.trim();

      if (firstName.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter your first name');
        return;
      }

      final rawDob = dobController.text.trim();
      if (rawDob.isEmpty) {
        Get.snackbar('Validation Error', 'Please select your date of birth');
        return;
      }

      final parts = rawDob.split('/');
      if (parts.length == 3) {
        // Convert DD/MM/YYYY to YYYY-MM-DD
        dob = '${parts[2]}-${parts[1]}-${parts[0]}';
      } else {
        dob = rawDob;
      }
    } else {
      firstName = clubNameController.text.trim();
      lastName = '';

      if (firstName.isEmpty) {
        Get.snackbar('Validation Error', 'Please enter your club name');
        return;
      }
    }

    final Map<String, dynamic> requestBody = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'registration_type': registrationType,
    };

    if (dob != null && dob.isNotEmpty) {
      requestBody['dob'] = dob;
    }

    try {
      isLoading.value = true;

      final formData = FormData.fromMap(requestBody);

      final response = await _apiService.upload(
        ApiEndpoints.register,
        formData: formData,
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Registration successful! Please verify OTP.',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.toNamed(
          AppRoute.otpVerificationView,
          arguments: {
            'role': selectedRole.value.name,
            'type': 'signup',
            'email': email,
          },
        );
      }
    } catch (e) {
      debugPrint('Registration Error: $e');
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    Get.snackbar(
      'Coming Soon',
      'Google sign-in is not yet implemented.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectDate(DateTime selectedDate) {
    dobController.text =
        "${selectedDate.day.toString().padLeft(2, '0')}/"
        "${selectedDate.month.toString().padLeft(2, '0')}/"
        "${selectedDate.year}";
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();

    firstNameController.clear();
    lastNameController.clear();
    dobController.clear();

    clubNameController.clear();
    phoneController.clear();

    signupEmailController.clear();
    signupPasswordController.clear();
    confirmPasswordController.clear();

    super.onClose();
  }
}
