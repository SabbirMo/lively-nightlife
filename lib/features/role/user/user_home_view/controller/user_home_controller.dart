import 'dart:convert';
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
  final postingPostIds = <dynamic>{}.obs;

  bool isPosting(dynamic postId) => postingPostIds.contains(postId);

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
    if (post.showComments.value &&
        post.comments.isEmpty &&
        post.commentCount.value > 0) {
      fetchComments(post);
    }
  }

  Future<void> fetchComments(FeedPostModel post) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.postComments(post.id),
        requireAuth: true,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        List<dynamic>? rawList;
        if (data is List) {
          rawList = data;
        } else if (data is Map<String, dynamic>) {
          if (data['results'] is List) {
            rawList = data['results'] as List;
          } else if (data['comments'] is List) {
            rawList = data['comments'] as List;
          } else if (data['data'] is List) {
            rawList = data['data'] as List;
          }
        }
        if (rawList != null) {
          final loaded = <CommentModel>[];
          for (final item in rawList) {
            if (item is Map<String, dynamic>) {
              loaded.add(CommentModel.fromJson(item));
            }
          }
          loaded.sort((a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              return a.createdAt!.compareTo(b.createdAt!);
            }
            return 0;
          });
          post.comments.assignAll(loaded);
        }
      }
    } catch (e) {
      debugPrint('Error fetching comments: $e');
    }
  }

  Future<void> addComment(FeedPostModel post, String comment) async {
    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) return;
    if (post.id == null || post.isPostingComment.value) return;

    post.isPostingComment.value = true;
    postingPostIds.add(post.id);

    final myName = name.isNotEmpty ? name : 'You';
    final myPic = profileImageUrl.isNotEmpty ? profileImageUrl : null;

    final tempComment = CommentModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      userId: userProfile.value?.id?.toString(),
      username: userProfile.value?.username,
      userName: myName,
      comment: trimmedComment,
      time: 'Just now',
      profileImage: myPic,
      createdAt: DateTime.now(),
    );

    // Optimistic UI updates
    post.comments.add(tempComment);
    post.commentCount.value++;
    commentController.clear();

    try {
      final response = await _apiService.post(
        ApiEndpoints.postComments(post.id),
        data: {'text': trimmedComment},
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }

        if (data != null && data is Map<String, dynamic>) {
          Map<String, dynamic>? commentJson;
          if (data.containsKey('id') ||
              data.containsKey('text') ||
              data.containsKey('comment')) {
            commentJson = data;
          } else if (data['data'] is Map<String, dynamic>) {
            commentJson = data['data'] as Map<String, dynamic>;
          } else if (data['comment'] is Map<String, dynamic>) {
            commentJson = data['comment'] as Map<String, dynamic>;
          }

          if (commentJson != null) {
            final parsedComment = CommentModel.fromJson(commentJson);
            final finalComment = CommentModel(
              id: parsedComment.id ?? tempComment.id,
              userId: parsedComment.userId ?? userProfile.value?.id?.toString(),
              username: parsedComment.username ?? userProfile.value?.username,
              userName:
                  (parsedComment.userName.isNotEmpty &&
                      parsedComment.userName != 'User')
                  ? parsedComment.userName
                  : myName,
              comment: parsedComment.comment.isNotEmpty
                  ? parsedComment.comment
                  : trimmedComment,
              time:
                  parsedComment.time.isNotEmpty &&
                      parsedComment.time != 'Recently'
                  ? parsedComment.time
                  : 'Just now',
              profileImage: parsedComment.profileImage ?? myPic,
              createdAt: parsedComment.createdAt ?? tempComment.createdAt,
            );

            final index = post.comments.indexWhere(
              (c) => c.id == tempComment.id,
            );
            if (index != -1) {
              post.comments[index] = finalComment;
            }
          }

          if (data.containsKey('comments_count') &&
              data['comments_count'] is int) {
            post.commentCount.value = data['comments_count'] as int;
          }
        }
      } else {
        // Rollback
        post.comments.removeWhere((c) => c.id == tempComment.id);
        if (post.commentCount.value > 0) {
          post.commentCount.value--;
        }
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
      // Rollback
      post.comments.removeWhere((c) => c.id == tempComment.id);
      if (post.commentCount.value > 0) {
        post.commentCount.value--;
      }
    } finally {
      post.isPostingComment.value = false;
      postingPostIds.remove(post.id);
      post.comments.refresh();
    }
  }

  bool isMyComment(CommentModel comment) {
    final myId = userProfile.value?.id;
    if (myId != null &&
        comment.userId != null &&
        myId.toString() == comment.userId.toString()) {
      return true;
    }
    final myUsername = userProfile.value?.username?.trim();
    if (myUsername != null &&
        myUsername.isNotEmpty &&
        comment.username != null &&
        myUsername.toLowerCase() == comment.username!.trim().toLowerCase()) {
      return true;
    }
    if (comment.id != null && comment.id!.startsWith('temp_')) {
      return true;
    }
    if (comment.userName == 'You') return true;
    final myFullName = name.trim();
    if (myFullName.isNotEmpty &&
        comment.userName.trim().toLowerCase() == myFullName.toLowerCase()) {
      return true;
    }
    return false;
  }

  Future<void> updateComment(
    FeedPostModel post,
    CommentModel comment,
    String newText,
  ) async {
    final trimmed = newText.trim();
    if (trimmed.isEmpty || trimmed == comment.comment) return;
    if (comment.id == null) return;

    final originalComment = comment.comment;
    final index =
        post.comments.indexWhere((c) => c.id != null && c.id == comment.id);
    if (index == -1) return;

    // Optimistic update
    final updatedComment = post.comments[index].copyWith(comment: trimmed);
    post.comments[index] = updatedComment;
    post.comments.refresh();

    try {
      final response = await _apiService.patch(
        ApiEndpoints.postCommentDetail(post.id, comment.id),
        data: {'text': trimmed},
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        dynamic data = response.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }
        if (data != null && data is Map<String, dynamic>) {
          Map<String, dynamic>? commentJson;
          if (data.containsKey('id') ||
              data.containsKey('text') ||
              data.containsKey('comment')) {
            commentJson = data;
          } else if (data['data'] is Map<String, dynamic>) {
            commentJson = data['data'] as Map<String, dynamic>;
          } else if (data['comment'] is Map<String, dynamic>) {
            commentJson = data['comment'] as Map<String, dynamic>;
          }

          final serverComment = commentJson != null
              ? CommentModel.fromJson(commentJson)
              : CommentModel.fromJson(data);

          final currentIndex = post.comments.indexWhere(
            (c) => c.id != null && c.id == comment.id,
          );
          if (currentIndex != -1) {
            post.comments[currentIndex] = post.comments[currentIndex].copyWith(
              comment: serverComment.comment.isNotEmpty
                  ? serverComment.comment
                  : trimmed,
              time: serverComment.time.isNotEmpty ? serverComment.time : null,
            );
            post.comments.refresh();
          }
        }
      } else {
        // Rollback
        final rollbackIndex = post.comments.indexWhere(
          (c) => c.id != null && c.id == comment.id,
        );
        if (rollbackIndex != -1) {
          post.comments[rollbackIndex] =
              post.comments[rollbackIndex].copyWith(comment: originalComment);
          post.comments.refresh();
        }
      }
    } catch (e) {
      debugPrint('Error updating comment: $e');
      final rollbackIndex = post.comments.indexWhere(
        (c) => c.id != null && c.id == comment.id,
      );
      if (rollbackIndex != -1) {
        post.comments[rollbackIndex] =
            post.comments[rollbackIndex].copyWith(comment: originalComment);
        post.comments.refresh();
      }
    }
  }

  Future<void> deleteComment(
    FeedPostModel post,
    CommentModel comment,
  ) async {
    if (comment.id == null) return;

    final index =
        post.comments.indexWhere((c) => c.id != null && c.id == comment.id);
    if (index == -1) return;

    final removedComment = post.comments[index];

    // Optimistic removal
    post.comments.removeAt(index);
    if (post.commentCount.value > 0) {
      post.commentCount.value--;
    }
    post.comments.refresh();

    try {
      final response = await _apiService.delete(
        ApiEndpoints.postCommentDetail(post.id, comment.id),
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Successfully deleted
      } else {
        // Rollback
        post.comments.insert(index, removedComment);
        post.commentCount.value++;
        post.comments.refresh();
      }
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      // Rollback
      post.comments.insert(index, removedComment);
      post.commentCount.value++;
      post.comments.refresh();
    }
  }

  Future<bool> reportComment(
    CommentModel comment, {
    required String reason,
    required String description,
  }) async {
    if (comment.id == null) return false;

    try {
      final response = await _apiService.post(
        ApiEndpoints.reportComment(comment.id),
        data: {
          'reason': reason.trim(),
          'description': description.trim(),
        },
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      }
    } catch (e) {
      debugPrint('Error reporting comment: $e');
    }
    return false;
  }

  Future<void> sharePost(FeedPostModel post) async {
    post.shareCount.value++;

    final buffer = StringBuffer();
    if (post.caption.isNotEmpty) {
      buffer.writeln(post.caption);
    }
    if (post.hashtags.isNotEmpty) {
      buffer.writeln(post.hashtags);
    }
    final details = <String>[];
    if (post.userName.isNotEmpty) {
      details.add('by @${post.userName}');
    }
    if (post.location.isNotEmpty) {
      details.add('at ${post.location}');
    }
    if (details.isNotEmpty) {
      buffer.writeln(details.join(' '));
    }
    if (post.image.isNotEmpty &&
        (post.image.startsWith('http://') ||
            post.image.startsWith('https://'))) {
      buffer.writeln('\n${post.image}');
    }
    buffer.writeln('\nShared via Lively Nightlife');

    // ignore: deprecated_member_use
    await Share.share(
      buffer.toString().trim(),
      subject: post.caption.isNotEmpty
          ? post.caption
          : 'Post by @${post.userName} on Lively',
    );

    try {
      final response = await _apiService.post(
        ApiEndpoints.postShare(post.id),
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (data.containsKey('shares_count') && data['shares_count'] is int) {
            post.shareCount.value = data['shares_count'] as int;
          }
        }
      }
    } catch (e) {
      debugPrint('Error recording post share: $e');
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    commentController.dispose();
    super.onClose();
  }
}
