import 'package:get/get.dart';

enum UserNotificationType {
  like,
  comment,
  follow,
  checkIn,
  event,
  ticket,
  nearby,
}

class UserNotificationModel {
  final String id;
  final String userName;
  final String message;
  final String time;
  final String profileImage;
  final String? postImage;
  final UserNotificationType type;
  final RxBool isRead;

  UserNotificationModel({
    required this.id,
    required this.userName,
    required this.message,
    required this.time,
    required this.profileImage,
    this.postImage,
    required this.type,
    bool isRead = false,
  }) : isRead = isRead.obs;
}