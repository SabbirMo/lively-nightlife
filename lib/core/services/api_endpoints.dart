class ApiEndpoints {
  static const String baseUrl = 'https://hecticly-rural-kittie.ngrok-free.dev';

  // Auth & Token Endpoints
  static const String login = '/api/users/login/';
  static const String register = '/api/users/register/';
  static const String getOtp = '/auth/api/v1/get-otp/';
  static const String verifyOtp = '/api/users/verify-otp/';
  static const String resendOtp = '/api/users/resend-otp/';
  static const String refreshToken = '/api/users/login/refresh/';
  static const String forgotPassword = '/api/users/password/forgot/';
  static const String passwordVerifyOtp = '/api/users/password/verify-otp/';
  static const String resetPassword = '/api/users/password/reset/';
  static const String changePassword = '/api/users/password/change/';
  static const String changeEmail = '/api/users/email/change/';
  static const String userProfile = '/api/users/profile/';
}
