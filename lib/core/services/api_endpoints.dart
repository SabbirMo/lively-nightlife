class ApiEndpoints {
  static const String baseUrl = 'https://hecticly-rural-kittie.ngrok-free.dev';

  // Auth & Token Endpoints
  static const String login = '/api/users/login/';
  static const String register = '/api/users/register/';
  static const String getOtp = '/auth/api/v1/get-otp/';
  static const String verifyOtp = '/api/users/verify-otp/';
  static const String resendOtp = '/api/users/resend-otp/';
  static const String refreshToken = '/api/users/token/refresh/';
  static const String forgotPassword = '/api/users/password/forgot/';
  static const String resetPassword = '/auth/api/v1/reset-password/';

  // // User & Friends Endpoints
  // static const String getFriendSuggestions = '/auth/api/v1/friend-suggestions/';
  // static const String getFollowingFriends = '/auth/api/v1/following/';

  // // TMDB / Movies / Events Endpoints
  // static const String getProviders = '/tmdb/api/v1/providers/get/';
  // static const String getGenres = '/tmdb/api/v1/genres/get/';
  // static const String getHomeData = '/tmdb/api/v1/home/get';
  // static const String getFeedPosts = '/tmdb/api/v1/feed/get/';
  // static const String getMovieSearch = '/tmdb/api/v1/movie/search/';
  // static const String getMovieDetails = '/tmdb/api/v1/movie/';
  // static const String getPostComments = '/tmdb/api/v1/post/comments/';
  // static const String postFeedLike = '/tmdb/api/v1/post/like/';
  // static const String postFeedComment = '/tmdb/api/v1/post/comment/add/';
  // static const String postMovieReview = '/tmdb/api/v1/post/review/add/';
  // static const String postRatingLike = '/tmdb/api/v1/rating/like/';
  // static const String postRatingComment = '/tmdb/api/v1/rating/comment/add/';
  // static const String getRatingComments = '/tmdb/api/v1/rating/';
  // static const String addWatchlist = '/tmdb/api/v1/watchlist/add/';
  // static const String removeWatchlist = '/tmdb/api/v1/watchlist/remove/';
  // static const String getWatchlist = '/tmdb/api/v1/watchlist/';

  // // Notifications Endpoints
  // static const String getNotifications = '/fcm/api/v1/notifications/';
  // static const String readNotification = '/fcm/api/v1/notifications/read/';
}
