import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'comment_model.dart';

class FeedPostModel {
  final dynamic id;
  final String userName;
  final String profileImage;
  final String location;
  final String time;
  final String image;
  final String caption;
  final String hashtags;
  final List<String>? images;

  RxBool isLiked;
  RxBool isSaved;
  RxBool isFollowing;
  RxBool showComments;

  RxInt likeCount;
  RxInt commentCount;
  RxInt shareCount;

  RxList<CommentModel> comments;

  FeedPostModel({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.location,
    required this.time,
    required this.image,
    required this.caption,
    required this.hashtags,
    required bool isLiked,
    required bool isSaved,
    required bool isFollowing,
    required int likeCount,
    required int commentCount,
    required int shareCount,
    required List<CommentModel> comments,
    this.images,
  })  : isLiked = isLiked.obs,
        isSaved = isSaved.obs,
        isFollowing = isFollowing.obs,
        showComments = false.obs,
        likeCount = likeCount.obs,
        commentCount = commentCount.obs,
        shareCount = shareCount.obs,
        comments = comments.obs;

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final caption = json['caption']?.toString() ?? '';

    // Hashtags from tags array
    String hashtags = '';
    final tagsList = json['tags'];
    if (tagsList is List) {
      hashtags = tagsList
          .where((t) => t != null && t.toString().trim().isNotEmpty)
          .map((t) =>
              t.toString().trim().startsWith('#')
                  ? t.toString().trim()
                  : '#${t.toString().trim()}')
          .join(' ');
    }

    // Venue or User Name
    final venueName = json['venue_name']?.toString().trim() ?? '';
    final venueUsername = json['venue_username']?.toString().trim() ?? '';
    final userName = venueName.isNotEmpty
        ? venueName
        : (venueUsername.isNotEmpty ? venueUsername : 'Lively Venue');

    // Profile Pic
    String profilePic = json['profile_pic']?.toString() ?? '';
    if (profilePic.isNotEmpty) {
      profilePic = _resolveUrl(profilePic);
    }

    // Location
    final location = json['location_name']?.toString() ?? '';

    // Time from created_at
    final createdAt = json['created_at']?.toString();
    String timeStr = '';
    if (createdAt != null && createdAt.isNotEmpty) {
      final dt = DateTime.tryParse(createdAt);
      if (dt != null) {
        final diff = DateTime.now().difference(dt.toLocal());
        if (diff.inMinutes < 1) {
          timeStr = 'Just now';
        } else if (diff.inMinutes < 60) {
          timeStr = '${diff.inMinutes}m';
        } else if (diff.inHours < 24) {
          timeStr = '${diff.inHours}h';
        } else if (diff.inDays < 7) {
          timeStr = '${diff.inDays}d';
        } else {
          timeStr = '${(diff.inDays / 7).floor()}w';
        }
      }
    }

    // Media
    final List<String> mediaUrls = [];
    final rawMedia = json['media'];
    if (rawMedia is List) {
      for (final m in rawMedia) {
        if (m is String && m.isNotEmpty) {
          mediaUrls.add(_resolveUrl(m));
        } else if (m is Map) {
          final fileUrl =
              m['file'] ?? m['media_file'] ?? m['url'] ?? m['image'];
          if (fileUrl != null && fileUrl.toString().isNotEmpty) {
            mediaUrls.add(_resolveUrl(fileUrl.toString()));
          }
        }
      }
    }

    final postImage =
        mediaUrls.isNotEmpty ? mediaUrls.first : ImagePath.feedImage;

    // Counts
    final likesCount = json['likes_count'] is int
        ? json['likes_count'] as int
        : int.tryParse(json['likes_count']?.toString() ?? '0') ?? 0;
    final commentsCount = json['comments_count'] is int
        ? json['comments_count'] as int
        : int.tryParse(json['comments_count']?.toString() ?? '0') ?? 0;
    final sharesCount = json['shares_count'] is int
        ? json['shares_count'] as int
        : int.tryParse(json['shares_count']?.toString() ?? '0') ?? 0;

    // Boolean states
    final isLiked = json['is_liked'] == true;
    final isSaved = json['is_saved'] == true;
    final isFollowing = json['is_following_venue'] == true;

    // Recent comments
    final List<CommentModel> comments = [];
    if (json['recent_comments'] is List) {
      for (final c in (json['recent_comments'] as List)) {
        if (c is Map<String, dynamic>) {
          comments.add(CommentModel.fromJson(c));
        }
      }
    }

    return FeedPostModel(
      id: id,
      userName: userName,
      profileImage: profilePic,
      location: location,
      time: timeStr.isNotEmpty ? timeStr : 'Recently',
      image: postImage,
      caption: caption,
      hashtags: hashtags,
      images: mediaUrls,
      isLiked: isLiked,
      isSaved: isSaved,
      isFollowing: isFollowing,
      likeCount: likesCount,
      commentCount: commentsCount,
      shareCount: sharesCount,
      comments: comments,
    );
  }

  static String _resolveUrl(String? url) {
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
}

class ForYouResponseModel {
  final String? next;
  final String? previous;
  final List<FeedPostModel> results;

  ForYouResponseModel({
    this.next,
    this.previous,
    required this.results,
  });

  factory ForYouResponseModel.fromJson(Map<String, dynamic> json) {
    final resultsList = <FeedPostModel>[];
    if (json['results'] is List) {
      for (final item in (json['results'] as List)) {
        if (item is Map<String, dynamic>) {
          resultsList.add(FeedPostModel.fromJson(item));
        }
      }
    }
    return ForYouResponseModel(
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: resultsList,
    );
  }
}