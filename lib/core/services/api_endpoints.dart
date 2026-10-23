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

  // Social Endpoints
  static const String forYou = '/api/social/for-you/';
  static const String followingFeed = '/api/social/following/';
  static const String nearbyFeed = '/api/social/feed/nearby/';
  static String postLike(dynamic id) => '/api/social/posts/$id/like/';
  static String postSave(dynamic id) => '/api/social/posts/$id/save_post/';
  static String postShare(dynamic id) => '/api/social/posts/$id/share/';
  static String postComments(dynamic postPk) =>
      '/api/social/posts/$postPk/comments/';
  static String postCommentDetail(dynamic postPk, dynamic commentId) =>
      '/api/social/posts/$postPk/comments/$commentId/';
  static String reportComment(dynamic commentId) =>
      '/api/social/comments/$commentId/report/';
}
