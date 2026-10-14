import 'user_message_model.dart';

class UserChatModel {
  final String id;
  final String name;
  final String avatar;
  final String lastSeen;
  final bool isOnline;
  final String time;
  final int unreadCount;
  final List<UserMessageModel> messages;
  final bool isClub;

  const UserChatModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastSeen,
    required this.isOnline,
    required this.time,
    required this.unreadCount,
    required this.messages,
    this.isClub = false,
  });

  UserChatModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? lastSeen,
    bool? isOnline,
    String? time,
    int? unreadCount,
    List<UserMessageModel>? messages,
    bool? isClub,
  }) {
    return UserChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
      isClub: isClub ?? this.isClub,
    );
  }
}
