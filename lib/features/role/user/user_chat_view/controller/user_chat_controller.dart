import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/model/user_discover_club_model.dart';
import '../model/user_chat_model.dart';
import '../model/user_message_model.dart';
import '../model/user_story_model.dart';

class UserChatController extends GetxController {
  final RxInt selectedTab =
      0.obs; // 0: For You, 1: Following, 2: Nearby, 3: Trending
  final messageInputController = TextEditingController();
  final activeChat = Rxn<UserChatModel>();

  final RxList<UserStoryModel> stories = <UserStoryModel>[].obs;
  final RxList<UserChatModel> chatsList = <UserChatModel>[].obs;
  final RxList<UserChatModel> filteredChats = <UserChatModel>[].obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    _loadDemoStories();
    _loadDemoChats();
    filterChats();

    ever(selectedTab, (_) => filterChats());
    super.onInit();
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void filterChats() {
    final clubChats = chatsList.where((c) => c.isClub).toList();
    if (selectedTab.value == 0) {
      filteredChats.assignAll(clubChats);
    } else if (selectedTab.value == 1) {
      filteredChats.assignAll(clubChats.where((c) => c.isOnline).toList());
    } else if (selectedTab.value == 2) {
      filteredChats.assignAll(clubChats.take(3).toList());
    } else {
      filteredChats.assignAll(clubChats.skip(2).toList());
    }
  }

  void selectChat(UserChatModel chat) {
    activeChat.value = chat;
    // Mark as read when selected
    final idx = chatsList.indexWhere((c) => c.id == chat.id);
    if (idx != -1) {
      final updated = chatsList[idx].copyWith(unreadCount: 0);
      _updateAndSyncChat(updated);
    }
  }

  void _updateAndSyncChat(UserChatModel updatedChat) {
    // Update in chatsList
    final idx = chatsList.indexWhere((c) => c.id == updatedChat.id);
    if (idx != -1) {
      chatsList[idx] = updatedChat;
    } else {
      chatsList.add(updatedChat);
    }

    // Update activeChat if it's the one currently being viewed
    if (activeChat.value?.id == updatedChat.id) {
      activeChat.value = updatedChat;
    }

    // Sync connection: club_omnia <-> user_alex
    if (updatedChat.id == 'club_omnia') {
      final alexIdx = chatsList.indexWhere((c) => c.id == 'user_alex');
      if (alexIdx != -1) {
        final alexChat = chatsList[alexIdx];
        // Only sync if the last message is different to prevent infinite loops
        if (alexChat.messages.isEmpty || 
            updatedChat.messages.isEmpty || 
            alexChat.messages.last.id != updatedChat.messages.last.id) {
          final newMessages = List<UserMessageModel>.from(updatedChat.messages);
          final updatedAlex = alexChat.copyWith(
            messages: newMessages,
            time: updatedChat.time,
          );
          chatsList[alexIdx] = updatedAlex;
          if (activeChat.value?.id == 'user_alex') {
            activeChat.value = updatedAlex;
          }
        }
      }
    } else if (updatedChat.id == 'user_alex') {
      final omniaIdx = chatsList.indexWhere((c) => c.id == 'club_omnia');
      if (omniaIdx != -1) {
        final omniaChat = chatsList[omniaIdx];
        if (omniaChat.messages.isEmpty || 
            updatedChat.messages.isEmpty || 
            omniaChat.messages.last.id != updatedChat.messages.last.id) {
          final newMessages = List<UserMessageModel>.from(updatedChat.messages);
          final updatedOmnia = omniaChat.copyWith(
            messages: newMessages,
            time: updatedChat.time,
          );
          chatsList[omniaIdx] = updatedOmnia;
          if (activeChat.value?.id == 'club_omnia') {
            activeChat.value = updatedOmnia;
          }
        }
      }
    }

    filterChats();
  }

  void shareClubOrEvent(String userName, UserDiscoverClubModel item) {
    final idx = chatsList.indexWhere(
      (c) => c.name.toLowerCase().contains(userName.toLowerCase()),
    );
    UserChatModel chat;
    if (idx != -1) {
      chat = chatsList[idx];
    } else {
      chat = UserChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: userName,
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        lastSeen: 'Active now',
        isOnline: true,
        time: 'Just now',
        unreadCount: 0,
        messages: [],
      );
    }

    final newMessage = UserMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Shared a ${item.type == "event" ? "event" : "club"}: ${item.name}',
      isMe: true,
      time: DateTime.now(),
      sharedClubOrEvent: item,
    );

    final updatedMessages = List<UserMessageModel>.from(chat.messages)
      ..add(newMessage);
    final updatedChat = chat.copyWith(
      messages: updatedMessages,
      time: 'Just now',
    );

    _updateAndSyncChat(updatedChat);
  }

  Future<void> createStory(bool fromCamera, {bool isVideo = false}) async {
    try {
      XFile? file = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (file != null) {
        final myStoryIdx = stories.indexWhere((s) => s.isYourStory);
        if (myStoryIdx != -1) {
          stories[myStoryIdx] = stories[myStoryIdx].copyWith(
            mediaPath: file.path,
            isVideo: isVideo,
          );
          stories.refresh();
          Get.snackbar(
            'Story Uploaded',
            'Your new ${isVideo ? "video" : "photo"} story is now live!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture story: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickFileAttachment({bool sentByClub = false}) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final platformFile = result.files.single;
        sendAttachmentMessage(
          filePath: platformFile.path,
          fileName: platformFile.name,
          fileSize:
              '${(platformFile.size / (1024 * 1024)).toStringAsFixed(1)} MB',
          sentByClub: sentByClub,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickImageAttachment(bool fromCamera, {bool sentByClub = false}) async {
    try {
      final file = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (file != null) sendAttachmentMessage(imagePath: file.path, sentByClub: sentByClub);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void sendMessage(String text, {bool sentByClub = false}) {
    if (text.trim().isEmpty || activeChat.value == null) return;
    _addMessageToActiveChat(
      UserMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: !sentByClub,
        time: DateTime.now(),
        sentByClub: sentByClub,
      ),
    );
    messageInputController.clear();
  }

  void sendAttachmentMessage({
    String? imagePath,
    String? filePath,
    String? fileName,
    String? fileSize,
    bool sentByClub = false,
  }) {
    if (activeChat.value == null) return;
    _addMessageToActiveChat(
      UserMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: imagePath != null ? 'Sent an image' : (fileName ?? 'Sent a file'),
        isMe: !sentByClub,
        time: DateTime.now(),
        imagePath: imagePath,
        filePath: filePath,
        fileName: fileName,
        fileSize: fileSize,
        sentByClub: sentByClub,
      ),
    );
  }

  void _addMessageToActiveChat(UserMessageModel msg) {
    final chat = activeChat.value;
    if (chat == null) return;
    final updatedChat = chat.copyWith(
      messages: List<UserMessageModel>.from(chat.messages)..add(msg),
      time: 'Just now',
    );
    _updateAndSyncChat(updatedChat);
  }

  void _loadDemoStories() {
    stories.assignAll([
      const UserStoryModel(
        id: '1',
        name: 'Your story',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        isYourStory: true,
      ),
      const UserStoryModel(
        id: '2',
        name: 'luna',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        isYourStory: false,
      ),
      const UserStoryModel(
        id: '3',
        name: 'Dj',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        isYourStory: false,
      ),
      const UserStoryModel(
        id: '4',
        name: 'zara',
        avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9',
        isYourStory: false,
      ),
    ]);
  }

  void _loadDemoChats() {
    chatsList.assignAll([
      UserChatModel(
        id: 'club_omnia',
        name: 'Omnia Nightclub',
        avatar: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
        lastSeen: 'Active now',
        isOnline: true,
        time: '10:24 PM',
        unreadCount: 1,
        isClub: true,
        messages: [
          UserMessageModel(
            id: 'omnia_1',
            text: 'Welcome to Omnia! Tonight we have Martin Garrix live. Don\'t miss out!',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 30)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: 'club_marquee',
        name: 'Marquee Nightclub',
        avatar: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819',
        lastSeen: 'Active now',
        isOnline: true,
        time: '09:15 PM',
        unreadCount: 0,
        isClub: true,
        messages: [
          UserMessageModel(
            id: 'marquee_1',
            text: 'Hey! Ready for the weekend party at Marquee?',
            isMe: false,
            time: DateTime.now().subtract(const Duration(hours: 2)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: 'club_hakkasan',
        name: 'Hakkasan Nightclub',
        avatar: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        lastSeen: 'Active 1h ago',
        isOnline: false,
        time: 'Yesterday',
        unreadCount: 0,
        isClub: true,
        messages: [
          UserMessageModel(
            id: 'hakkasan_1',
            text: 'Your reservation for VIP Table 4 has been confirmed.',
            isMe: false,
            time: DateTime.now().subtract(const Duration(days: 1)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: 'club_xs',
        name: 'XS Nightclub',
        avatar: 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3',
        lastSeen: 'Active now',
        isOnline: true,
        time: 'Wednesday',
        unreadCount: 0,
        isClub: true,
        messages: [
          UserMessageModel(
            id: 'xs_1',
            text: 'Tickets for the Diplo event are selling out fast!',
            isMe: false,
            time: DateTime.now().subtract(const Duration(days: 3)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: 'club_zouk',
        name: 'Zouk Nightclub',
        avatar: 'https://images.unsplash.com/photo-1506157786151-b8491531f063',
        lastSeen: 'Active 2h ago',
        isOnline: false,
        time: 'Monday',
        unreadCount: 0,
        isClub: true,
        messages: [
          UserMessageModel(
            id: 'zouk_1',
            text: 'Thanks for visiting Zouk! Let us know how your experience was.',
            isMe: false,
            time: DateTime.now().subtract(const Duration(days: 5)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: 'user_alex',
        name: 'Alex Rivera',
        avatar: 'https://i.pravatar.cc/150?img=10',
        lastSeen: 'Active now',
        isOnline: true,
        time: '10:24 PM',
        unreadCount: 1,
        isClub: false,
        messages: [
          UserMessageModel(
            id: 'omnia_1',
            text: 'Welcome to Omnia! Tonight we have Martin Garrix live. Don\'t miss out!',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 30)),
            sentByClub: true,
          ),
        ],
      ),
      UserChatModel(
        id: '1',
        name: 'Sophia Carter',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        lastSeen: '2 hours ago',
        isOnline: true,
        time: '10:24 PM',
        unreadCount: 2,
        messages: [
          UserMessageModel(
            id: '1_1',
            text: 'Hey Liam, progress on draft?',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          UserMessageModel(
            id: '1_2',
            text: 'Almost done!',
            isMe: true,
            time: DateTime.now().subtract(const Duration(minutes: 4)),
          ),
          UserMessageModel(
            id: '1_3',
            text: 'That\'s good! Take a look at this chart.',
            isMe: false,
            time: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ],
      ),
      UserChatModel(
        id: '2',
        name: 'Ethan Parker',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        lastSeen: '3 hours ago',
        isOnline: false,
        time: '10:24 PM',
        unreadCount: 0,
        messages: [
          UserMessageModel(
            id: '2_1',
            text: 'Can you send me the files?',
            isMe: false,
            time: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      UserChatModel(
        id: '3',
        name: 'James Walker',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        lastSeen: '1 day ago',
        isOnline: false,
        time: '10:24 PM',
        unreadCount: 0,
        messages: [
          UserMessageModel(
            id: '3_1',
            text: 'Don\'t forget the deadline is this Friday.',
            isMe: false,
            time: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      UserChatModel(
        id: '4',
        name: 'Mia Davis',
        avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9',
        lastSeen: 'Active now',
        isOnline: true,
        time: '10:24 PM',
        unreadCount: 1,
        messages: [
          UserMessageModel(
            id: '4_1',
            text: 'It was great catching up earlier!',
            isMe: false,
            time: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
    ]);
  }

  @override
  void onClose() {
    messageInputController.dispose();
    super.onClose();
  }
}
