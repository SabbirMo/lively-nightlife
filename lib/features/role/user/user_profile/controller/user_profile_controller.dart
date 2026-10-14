import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/controller/user_event_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_event_model.dart';
import '../model/follow_user_model.dart';

class UserProfileController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0: Posts Grid, 1: Bookmarks/Saved, 2: Star/Events

  // Mock Lists for Grid tab (Posts posted by the user)
  final RxList<String> postsList = <String>[
    'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
    'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
    'https://images.unsplash.com/photo-1506157786151-b8491531f063',
    'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3',
    'https://images.unsplash.com/photo-1501386761578-eac5c94b800a',
    'https://images.unsplash.com/photo-1514525253161-7a46d19cd819',
  ].obs;

  // Master Users list for Follower / Following feature
  final RxList<FollowUserModel> allUsers = <FollowUserModel>[
    FollowUserModel(
      name: 'Ahmad Nur',
      username: '@ahmad_nur',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      isFollowing: false,
    ),
    FollowUserModel(
      name: 'Lina Hartono',
      username: '@lina_h',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      isFollowing: true,
    ),
    FollowUserModel(
      name: 'Rizky Putra',
      username: '@rizky_p',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      isFollowing: true,
    ),
    FollowUserModel(
      name: 'Siti Aisyah',
      username: '@siti_a',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      isFollowing: false,
    ),
    FollowUserModel(
      name: 'Budi Santoso',
      username: '@budi_s',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      isFollowing: false,
    ),
    FollowUserModel(
      name: 'Dewi Kartika',
      username: '@dewi_k',
      avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      isFollowing: true,
    ),
    FollowUserModel(
      name: 'Fajar Pratama',
      username: '@fajar_p',
      avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
      isFollowing: false,
    ),
    FollowUserModel(
      name: 'Maya Sari',
      username: '@maya_s',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      isFollowing: false,
    ),
  ].obs;

  final RxInt followingCountValue = 312.obs;

  List<FollowUserModel> get followersList => allUsers;
  List<FollowUserModel> get followingList => allUsers.where((u) => u.isFollowing.value).toList();

  // Retrieve saved posts from UserHomeController
  List<FeedPostModel> get savedPosts {
    if (Get.isRegistered<UserHomeController>()) {
      final homeController = Get.find<UserHomeController>();
      final saved = <FeedPostModel>[];
      final seenIds = <int>{};
      final allPosts = [
        ...homeController.forYouPosts,
        ...homeController.followingPosts,
        ...homeController.nearbyPosts,
      ];
      for (var post in allPosts) {
        if (post.isSaved.value && !seenIds.contains(post.id)) {
          saved.add(post);
          seenIds.add(post.id);
        }
      }
      return saved;
    }
    return [];
  }

  // Retrieve RSVP'd events from UserEventController
  List<UserEventModel> get rsvpedEvents {
    if (Get.isRegistered<UserEventController>()) {
      final eventController = Get.find<UserEventController>();
      return eventController.eventsList.where((e) => e.isRsvped.value).toList();
    }
    return [];
  }

  // Stats text getters
  String get postsCount => postsList.length.toString();
  String get followersCount => '2.8k';
  String get followingCount => followingCountValue.value.toString();
  String get eventsCount => rsvpedEvents.length.toString();

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleFollow(FollowUserModel user) {
    if (user.isFollowing.value) {
      user.isFollowing.value = false;
      followingCountValue.value--;
    } else {
      user.isFollowing.value = true;
      followingCountValue.value++;
    }
  }

  void addMockPost() {
    const newImage = 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30';
    postsList.insert(0, newImage);
    Get.snackbar(
      'Post Added',
      'Your nightlife post has been successfully shared!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
