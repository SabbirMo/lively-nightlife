import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_message_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_event_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_ticket_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/model/user_lineup_model.dart';
import '../model/follow_user_model.dart';
import 'user_profile_controller.dart';

class UserOtherProfileController extends GetxController {
  late final FollowUserModel user;
  final RxInt selectedTab = 0.obs; // 0: Grid, 1: Events

  final List<String> mockPosts = const [
    'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=300',
    'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300',
    'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=300',
    'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=300',
    'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=300',
    'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=300',
  ];

  late final List<UserEventModel> mockEvents;

  @override
  void onInit() {
    user = Get.arguments as FollowUserModel;
    _initMockEvents();
    super.onInit();
  }

  void _initMockEvents() {
    mockEvents = [
      UserEventModel(
        id: 'other_e1',
        name: 'ULTRA x Omnia: Martin Garrix Live',
        location: 'Omnia Nightclub, Las Vegas',
        date: '2026-06-25',
        time: '10:30 PM',
        duration: '10:30 PM - 4:00 AM',
        image: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=300',
        price: 75,
        categories: const ['EDM', 'Synthwave'],
        goingCount: '2,890',
        interestedCount: '8,450',
        isHot: true,
        isRsvped: false,
        description: 'Martin Garrix live at Omnia with an extraordinary audiovisual production.',
        tickets: const [
          UserTicketModel(id: 'ot1', name: 'General Admission', price: 75, available: 50, total: 500),
        ],
        lineup: const [
          UserLineupModel(name: 'Martin Garrix', role: 'Headliner', image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'),
        ],
      ),
      UserEventModel(
        id: 'other_e2',
        name: 'Omnia Nightclub Party Tour',
        location: 'Omnia Nightclub, Las Vegas',
        date: '2026-06-26',
        time: '11:00 PM',
        duration: '11:00 PM - 5:00 AM',
        image: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300',
        price: 45,
        categories: const ['EDM', 'Synthwave'],
        goingCount: '1,200',
        interestedCount: '4,500',
        isHot: false,
        isRsvped: false,
        description: 'Weekly Omnia signature party with resident DJs and special guest artists.',
        tickets: const [
          UserTicketModel(id: 'ot2', name: 'General Admission', price: 45, available: 100, total: 1000),
        ],
        lineup: const [
          UserLineupModel(name: 'Omnia Resident', role: 'Headliner', image: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'),
        ],
      ),
      UserEventModel(
        id: 'other_e3',
        name: 'Vegas Club Crawl Extravaganza',
        location: 'Omnia Nightclub, Las Vegas',
        date: '2026-06-27',
        time: '9:00 PM',
        duration: '9:00 PM - 3:00 AM',
        image: 'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=300',
        price: 30,
        categories: const ['EDM', 'Synthwave'],
        goingCount: '800',
        interestedCount: '2,100',
        isHot: false,
        isRsvped: false,
        description: 'Vegas club hop ending at the world-famous Omnia Nightclub with VIP entry.',
        tickets: const [
          UserTicketModel(id: 'ot3', name: 'Club Crawl Ticket', price: 30, available: 60, total: 300),
        ],
        lineup: const [
          UserLineupModel(name: 'Local Host', role: 'Guide', image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'),
        ],
      ),
    ];
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleFollow() {
    if (user.isFollowing.value) {
      user.isFollowing.value = false;
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().followingCountValue.value--;
      }
    } else {
      user.isFollowing.value = true;
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().followingCountValue.value++;
      }
    }
  }

  Future<void> shareExternally() async {
    await Share.share(
      'Check out ${user.name} (@${user.username})\'s profile on Lively!',
    );
  }

  void shareInApp(String contactName) {
    Get.back();
    final msgText = 'Check out ${user.name} (@${user.username})\'s profile on Lively!';
    if (Get.isRegistered<UserChatController>()) {
      final chatController = Get.find<UserChatController>();
      final idx = chatController.chatsList.indexWhere(
        (c) => c.name.toLowerCase().contains(contactName.toLowerCase()),
      );
      UserChatModel chat;
      if (idx != -1) {
        chat = chatController.chatsList[idx];
      } else {
        chat = UserChatModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: contactName,
          avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
          lastSeen: 'Active now',
          isOnline: true,
          time: 'Just now',
          unreadCount: 0,
          messages: [],
        );
        chatController.chatsList.add(chat);
      }

      final newMessage = UserMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: msgText,
        isMe: true,
        time: DateTime.now(),
      );

      final updatedMessages = List<UserMessageModel>.from(chat.messages)..add(newMessage);
      final updatedChat = chat.copyWith(
        messages: updatedMessages,
        time: 'Just now',
      );

      final targetIdx = chatController.chatsList.indexWhere((c) => c.name == chat.name);
      if (targetIdx != -1) {
        chatController.chatsList[targetIdx] = updatedChat;
        if (chatController.activeChat.value?.id == updatedChat.id) {
          chatController.activeChat.value = updatedChat;
        }
      }
      chatController.filterChats();
    }

    Get.snackbar(
      'Shared Inside App',
      'Profile shared with $contactName successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blueColor,
      colorText: AppColors.whiteColor,
    );
  }
}
