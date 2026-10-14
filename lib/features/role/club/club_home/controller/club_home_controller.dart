import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/comment_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/club_activity_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/club_event_model.dart';
import 'package:share_plus/share_plus.dart';

class ClubHomeController extends GetxController {
  final RxInt selectedTab = 0.obs;
  final commentController = TextEditingController();

  // Content tab metrics
  final RxString contentPostsCount = '247'.obs;
  final RxString contentViewsCount = '12.4M'.obs;
  final RxString contentLikesCount = '890k'.obs;
  final RxString contentSharesCount = '145k'.obs;

  // Content posts list
  final RxList<FeedPostModel> contentPosts = <FeedPostModel>[].obs;

  // Overview metrics
  final RxString revenue = '\$66,400'.obs;
  final RxString revenueChange = '+23%'.obs;
  
  final RxString followers = '892k'.obs;
  final RxString followersChange = '+4.2k'.obs;

  final RxString tickets = '1,328'.obs;
  final RxString ticketsChange = '+18%'.obs;

  final RxString heatScore = '98/100'.obs;
  final RxString heatScoreStatus = 'Trending'.obs;

  // Chart data: daily revenues for custom paint rendering
  final List<double> revenueData = [20.0, 18.0, 24.0, 38.0, 75.0, 58.0]; // Tue - Sun
  final List<String> chartDays = ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Follower Growth (6M) mock data
  final List<double> followerGrowthData = [45.0, 50.0, 56.0, 68.0, 80.0];
  final List<String> followerGrowthMonths = ['Feb', 'Mar', 'Apr', 'May', 'Jun'];

  // Weekly Tickets mock data
  final List<double> weeklyTicketsData = [28.0, 24.0, 35.0, 50.0, 75.0, 120.0, 95.0];
  final List<String> weeklyTicketsDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Upcoming events
  final RxList<ClubEventModel> upcomingEvents = <ClubEventModel>[].obs;

  // Recent activity list
  final List<ClubActivityModel> recentActivities = [
    ClubActivityModel(
      type: ActivityType.follower,
      message: 'New follower milestone: 892k followers!',
      time: '5m',
    ),
    ClubActivityModel(
      type: ActivityType.ticket,
      message: '48 new tickets sold for Martin Garrix event',
      time: '12m',
    ),
    ClubActivityModel(
      type: ActivityType.review,
      message: 'New 5-star review from luna_vibes',
      time: '1h',
    ),
    ClubActivityModel(
      type: ActivityType.warning,
      message: 'Event capacity at 82% — boost recommended',
      time: '2h',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUpcomingEvents();
    _loadContentPosts();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void _loadContentPosts() {
    contentPosts.assignAll([
      FeedPostModel(
        id: 1,
        userName: 'luna_vibes',
        profileImage: 'https://i.pravatar.cc/150?img=1',
        location: 'Story Nightclub, Miami',
        time: '2h',
        image: ImagePath.feedImage,
        caption: 'Last night at Story Miami was absolutely INSANE 🔥🔥 The energy was unreal...',
        hashtags: '#StoryMiami#NightlifeVibes#Miami',
        isLiked: false,
        isSaved: false,
        isFollowing: false,
        likeCount: 8400,
        commentCount: 342,
        shareCount: 189,
        comments: [
          CommentModel(
            userName: 'party_queen',
            comment: 'The vibes were INSANE 🔥🔥',
            time: '1h',
          ),
        ],
      ),
    ]);
  }

  void toggleLike(FeedPostModel post) {
    post.isLiked.toggle();
    if (post.isLiked.value) {
      post.likeCount.value++;
    } else {
      post.likeCount.value--;
    }
  }

  void toggleComments(FeedPostModel post) {
    post.showComments.toggle();
  }

  void addComment(FeedPostModel post, String text) {
    if (text.trim().isEmpty) return;
    post.comments.add(
      CommentModel(
        userName: 'You',
        comment: text,
        time: 'Now',
      ),
    );
    post.commentCount.value++;
    commentController.clear();
  }

  Future<void> shareExternally(FeedPostModel post) async {
    await Share.share('Check out this nightlife post on Lively!');
    post.shareCount.value++;
  }

  void addPost(FeedPostModel post) {
    contentPosts.insert(0, post);
    final count = int.tryParse(contentPostsCount.value) ?? 0;
    contentPostsCount.value = (count + 1).toString();
  }

  void _loadUpcomingEvents() {
    upcomingEvents.assignAll([
      ClubEventModel(
        id: '1',
        title: 'Omnia Nightclub',
        imagePath: ImagePath.clubCoverPhoto,
        isOpen: true,
        rating: 4.8,
        location: 'Las Vegas, NV',
        priceTier: '\$\$\$',
        rsvps: '2,890',
        ticketsSold: '560',
        revenue: '\$90.1k',
      ),
      ClubEventModel(
        id: '2',
        title: 'Omnia Nightclub',
        imagePath: ImagePath.clubCoverPhoto,
        isOpen: true,
        rating: 4.8,
        location: 'Las Vegas, NV',
        priceTier: '\$\$\$',
        rsvps: '2,890',
        ticketsSold: '560',
        revenue: '\$90.1k',
      ),
    ]);
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}

