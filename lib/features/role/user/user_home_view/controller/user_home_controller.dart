import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/model/user_profile_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/controller/user_profile_setting_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/controller/user_profile_controller.dart';
import '../model/comment_model.dart';
import '../model/feed_post_model.dart';

class UserHomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  final selectedTab = 0.obs;

  final commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final forYouPosts = <FeedPostModel>[].obs;
  final followingPosts = <FeedPostModel>[].obs;
  final nearbyPosts = <FeedPostModel>[].obs;

  // Pagination & Loading States for For-You Feed
  final isLoadingForYou = false.obs;
  final isLoadingMore = false.obs;
  final hasNextPage = true.obs;
  String? _nextUrl;
  int _currentPage = 1;

  // Pagination & Loading States for Following Feed
  final isLoadingFollowing = false.obs;
  final isLoadingMoreFollowing = false.obs;
  final hasNextPageFollowing = true.obs;
  String? _nextUrlFollowing;
  int _currentPageFollowing = 1;

  // Pagination & Loading States for Nearby Feed
  final isLoadingNearby = false.obs;
  final isLoadingMoreNearby = false.obs;
  final hasNextPageNearby = true.obs;
  String? _nextUrlNearby;
  int _currentPageNearby = 1;

  List<FeedPostModel> get currentPosts {
    switch (selectedTab.value) {
      case 1:
        return followingPosts;

      case 2:
        return nearbyPosts;

      default:
        return forYouPosts;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    fetchUserProfile();
    fetchForYouPosts();
    fetchFollowingPosts();
    fetchNearbyPosts();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 250) {
        if (selectedTab.value == 0 &&
            !isLoadingForYou.value &&
            !isLoadingMore.value &&
            hasNextPage.value) {
          loadMoreForYouPosts();
        } else if (selectedTab.value == 1 &&
            !isLoadingFollowing.value &&
            !isLoadingMoreFollowing.value &&
            hasNextPageFollowing.value) {
          loadMoreFollowingPosts();
        } else if (selectedTab.value == 2 &&
            !isLoadingNearby.value &&
            !isLoadingMoreNearby.value &&
            hasNextPageNearby.value) {
          loadMoreNearbyPosts();
        }
      }
    });
  }

  // =================== FOR YOU FEED ===================

  Future<void> fetchForYouPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _nextUrl = null;
      hasNextPage.value = true;
    } else {
      if (forYouPosts.isEmpty) {
        isLoadingForYou.value = true;
      }
      _currentPage = 1;
      _nextUrl = null;
      hasNextPage.value = true;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.forYou,
        queryParameters: {'page': 1},
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          _nextUrl = data['next']?.toString();
          hasNextPage.value = _nextUrl != null && _nextUrl!.isNotEmpty;

          final rawResults = data['results'];
          if (rawResults is List) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawResults) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            forYouPosts.assignAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching for-you posts: $e');
    } finally {
      isLoadingForYou.value = false;
    }
  }

  Future<void> loadMoreForYouPosts() async {
    if (isLoadingMore.value || !hasNextPage.value) return;

    isLoadingMore.value = true;
    _currentPage++;

    try {
      String requestPath = ApiEndpoints.forYou;
      Map<String, dynamic>? queryParams = {'page': _currentPage};

      if (_nextUrl != null && _nextUrl!.isNotEmpty) {
        try {
          final uri = Uri.parse(_nextUrl!);
          requestPath = uri.path;
          queryParams = uri.queryParameters.isNotEmpty
              ? uri.queryParameters
              : null;
        } catch (_) {
          requestPath = ApiEndpoints.forYou;
          queryParams = {'page': _currentPage};
        }
      }

      final response = await _apiService.get(
        requestPath,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          _nextUrl = data['next']?.toString();
          hasNextPage.value = _nextUrl != null && _nextUrl!.isNotEmpty;

          final rawResults = data['results'];
          if (rawResults is List) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawResults) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            forYouPosts.addAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more for-you posts: $e');
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  // =================== FOLLOWING FEED ===================

  Future<void> fetchFollowingPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPageFollowing = 1;
      _nextUrlFollowing = null;
      hasNextPageFollowing.value = true;
    } else {
      if (followingPosts.isEmpty) {
        isLoadingFollowing.value = true;
      }
      _currentPageFollowing = 1;
      _nextUrlFollowing = null;
      hasNextPageFollowing.value = true;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.followingFeed,
        queryParameters: {'page': 1},
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null) {
          List<dynamic>? rawList;
          if (data is Map<String, dynamic>) {
            _nextUrlFollowing = data['next']?.toString();
            hasNextPageFollowing.value =
                _nextUrlFollowing != null && _nextUrlFollowing!.isNotEmpty;
            if (data['results'] is List) {
              rawList = data['results'] as List;
            }
          } else if (data is List) {
            rawList = data;
            hasNextPageFollowing.value = false;
          }

          if (rawList != null) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawList) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            followingPosts.assignAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching following posts: $e');
    } finally {
      isLoadingFollowing.value = false;
    }
  }

  Future<void> loadMoreFollowingPosts() async {
    if (isLoadingMoreFollowing.value || !hasNextPageFollowing.value) return;

    isLoadingMoreFollowing.value = true;
    _currentPageFollowing++;

    try {
      String requestPath = ApiEndpoints.followingFeed;
      Map<String, dynamic>? queryParams = {'page': _currentPageFollowing};

      if (_nextUrlFollowing != null && _nextUrlFollowing!.isNotEmpty) {
        try {
          final uri = Uri.parse(_nextUrlFollowing!);
          requestPath = uri.path;
          queryParams = uri.queryParameters.isNotEmpty
              ? uri.queryParameters
              : null;
        } catch (_) {
          requestPath = ApiEndpoints.followingFeed;
          queryParams = {'page': _currentPageFollowing};
        }
      }

      final response = await _apiService.get(
        requestPath,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null) {
          List<dynamic>? rawList;
          if (data is Map<String, dynamic>) {
            _nextUrlFollowing = data['next']?.toString();
            hasNextPageFollowing.value =
                _nextUrlFollowing != null && _nextUrlFollowing!.isNotEmpty;
            if (data['results'] is List) {
              rawList = data['results'] as List;
            }
          } else if (data is List) {
            rawList = data;
            hasNextPageFollowing.value = false;
          }

          if (rawList != null) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawList) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            followingPosts.addAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more following posts: $e');
      _currentPageFollowing--;
    } finally {
      isLoadingMoreFollowing.value = false;
    }
  }

  // =================== NEARBY FEED ===================

  Future<void> fetchNearbyPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPageNearby = 1;
      _nextUrlNearby = null;
      hasNextPageNearby.value = true;
    } else {
      if (nearbyPosts.isEmpty) {
        isLoadingNearby.value = true;
      }
      _currentPageNearby = 1;
      _nextUrlNearby = null;
      hasNextPageNearby.value = true;
    }

    try {
      final Map<String, dynamic> queryParams = {'page': 1};
      if (userProfile.value?.lat != null && userProfile.value?.lng != null) {
        queryParams['lat'] = userProfile.value!.lat;
        queryParams['lng'] = userProfile.value!.lng;
      }

      final response = await _apiService.get(
        ApiEndpoints.nearbyFeed,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null) {
          List<dynamic>? rawList;
          if (data is Map<String, dynamic>) {
            _nextUrlNearby = data['next']?.toString();
            hasNextPageNearby.value =
                _nextUrlNearby != null && _nextUrlNearby!.isNotEmpty;
            if (data['results'] is List) {
              rawList = data['results'] as List;
            }
          } else if (data is List) {
            rawList = data;
            hasNextPageNearby.value = false;
          }

          if (rawList != null) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawList) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            nearbyPosts.assignAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching nearby posts: $e');
    } finally {
      isLoadingNearby.value = false;
    }
  }

  Future<void> loadMoreNearbyPosts() async {
    if (isLoadingMoreNearby.value || !hasNextPageNearby.value) return;

    isLoadingMoreNearby.value = true;
    _currentPageNearby++;

    try {
      String requestPath = ApiEndpoints.nearbyFeed;
      Map<String, dynamic>? queryParams = {'page': _currentPageNearby};

      if (_nextUrlNearby != null && _nextUrlNearby!.isNotEmpty) {
        try {
          final uri = Uri.parse(_nextUrlNearby!);
          requestPath = uri.path;
          queryParams = uri.queryParameters.isNotEmpty
              ? uri.queryParameters
              : null;
        } catch (_) {
          requestPath = ApiEndpoints.nearbyFeed;
          queryParams = {'page': _currentPageNearby};
        }
      }

      final response = await _apiService.get(
        requestPath,
        queryParameters: queryParams,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null) {
          List<dynamic>? rawList;
          if (data is Map<String, dynamic>) {
            _nextUrlNearby = data['next']?.toString();
            hasNextPageNearby.value =
                _nextUrlNearby != null && _nextUrlNearby!.isNotEmpty;
            if (data['results'] is List) {
              rawList = data['results'] as List;
            }
          } else if (data is List) {
            rawList = data;
            hasNextPageNearby.value = false;
          }

          if (rawList != null) {
            final List<FeedPostModel> loaded = [];
            for (final item in rawList) {
              if (item is Map<String, dynamic>) {
                loaded.add(FeedPostModel.fromJson(item));
              }
            }
            nearbyPosts.addAll(loaded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading more nearby posts: $e');
      _currentPageNearby--;
    } finally {
      isLoadingMoreNearby.value = false;
    }
  }

  // =================== PROFILE & OTHER ===================

  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.userProfile,
        requireAuth: true,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          userProfile.value = UserProfileModel.fromJson(response.data);
        }
      }
    } catch (_) {}
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

  String get profileImageUrl {
    String? url = userProfile.value?.profileImage;
    if ((url == null || url.isEmpty) &&
        Get.isRegistered<UserProfileController>()) {
      url = Get.find<UserProfileController>().userProfile.value?.profileImage;
    }
    if ((url == null || url.isEmpty) &&
        Get.isRegistered<UserProfileSettingController>()) {
      url = Get.find<UserProfileSettingController>()
          .userProfile
          .value
          ?.profileImage;
    }
    return _resolveUrl(url);
  }

  String get name {
    var profile = userProfile.value;
    if (profile == null && Get.isRegistered<UserProfileController>()) {
      profile = Get.find<UserProfileController>().userProfile.value;
    }
    if (profile == null && Get.isRegistered<UserProfileSettingController>()) {
      profile = Get.find<UserProfileSettingController>().userProfile.value;
    }
    final first = profile?.firstName?.trim() ?? '';
    final last = profile?.lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    return profile?.username ?? '';
  }

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 1 && followingPosts.isEmpty && !isLoadingFollowing.value) {
      fetchFollowingPosts();
    } else if (index == 2 && nearbyPosts.isEmpty && !isLoadingNearby.value) {
      fetchNearbyPosts();
    }
  }

  Future<void> toggleLike(FeedPostModel post) async {
    final previousLiked = post.isLiked.value;
    final previousCount = post.likeCount.value;

    // Optimistic UI update
    post.isLiked.value = !previousLiked;
    if (post.isLiked.value) {
      post.likeCount.value = previousCount + 1;
    } else {
      post.likeCount.value = (previousCount > 0) ? previousCount - 1 : 0;
    }

    try {
      final response = await _apiService.post(
        ApiEndpoints.postLike(post.id),
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (data.containsKey('is_liked') && data['is_liked'] is bool) {
            post.isLiked.value = data['is_liked'] as bool;
          }
          if (data.containsKey('likes_count') && data['likes_count'] is int) {
            post.likeCount.value = data['likes_count'] as int;
          }
        }
      } else {
        // Rollback on failure status
        post.isLiked.value = previousLiked;
        post.likeCount.value = previousCount;
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      // Rollback on network/error exception
      post.isLiked.value = previousLiked;
      post.likeCount.value = previousCount;
    }
  }

  Future<void> toggleSave(FeedPostModel post) async {
    final previousSaved = post.isSaved.value;

    // Optimistic UI update
    post.isSaved.value = !previousSaved;

    try {
      final response = await _apiService.post(
        ApiEndpoints.postSave(post.id),
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (data.containsKey('is_saved') && data['is_saved'] is bool) {
            post.isSaved.value = data['is_saved'] as bool;
          }
        }
      } else {
        // Rollback on failure status
        post.isSaved.value = previousSaved;
      }
    } catch (e) {
      debugPrint('Error toggling save post: $e');
      // Rollback on network/error exception
      post.isSaved.value = previousSaved;
    }
  }

  void toggleFollow(FeedPostModel post) {
    post.isFollowing.toggle();
  }

  void toggleComments(FeedPostModel post) {
    post.showComments.toggle();
  }

  void addComment(FeedPostModel post, String comment) {
    if (comment.trim().isEmpty) return;
    post.comments.add(
      CommentModel(userName: 'You', comment: comment, time: 'Now'),
    );

    post.commentCount.value++;
    commentController.clear();
  }

  Future<void> shareExternally() async {
    await Share.share('Check out this nightlife post on Lively!');
  }

  void shareInApp(String userName) {
    Get.back();

    Get.snackbar('Shared', 'Post shared with $userName');
  }

  @override
  void onClose() {
    scrollController.dispose();
    commentController.dispose();
    super.onClose();
  }
}
