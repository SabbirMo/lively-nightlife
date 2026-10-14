import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/model/user_notification_model.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserNotificationController extends GetxController {
  final selectedTab = 0.obs;

  final notifications = <UserNotificationModel>[].obs;

  @override
  void onInit() {
    loadDemoNotifications();
    super.onInit();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
 
  void markAllAsRead() {
    for (final item in notifications) {
      item.isRead.value = true;
    }
  }

  List<UserNotificationModel> get filteredNotifications {
    switch (selectedTab.value) {
      /// ALL
      case 0:
        return notifications;

      /// UNREAD
      case 1:
        return notifications.where((e) => !e.isRead.value).toList();

      /// READ
      case 2:
        return notifications.where((e) => e.isRead.value).toList();

      /// LIKES
      case 3:
        return notifications
            .where(
              (e) =>
                  e.type == UserNotificationType.like ||
                  e.type == UserNotificationType.comment,
            )
            .toList();

      /// SOCIAL
      case 4:
        return notifications
            .where(
              (e) =>
                  e.type == UserNotificationType.follow ||
                  e.type == UserNotificationType.checkIn,
            )
            .toList();

      /// EVENTS
      case 5:
        return notifications
            .where(
              (e) =>
                  e.type == UserNotificationType.event ||
                  e.type == UserNotificationType.ticket ||
                  e.type == UserNotificationType.nearby,
            )
            .toList();

      default:
        return notifications;
    }
  }

  void openNotification(UserNotificationModel notification) {
    notification.isRead.value = true;
    Get.toNamed(AppRoute.userNotificationReadView, arguments: notification);
  }

  void loadDemoNotifications() {
    notifications.assignAll([
      UserNotificationModel(
        id: '1',
        userName: 'luna_vibes',
        message: 'liked your post',
        time: '5m',
        profileImage: ImagePath.feedImage,
        postImage: ImagePath.feedImage,
        type: UserNotificationType.like,
      ),

      UserNotificationModel(
        id: '2',
        userName: 'dj_moxxx',
        message: 'started following you',
        time: '12m',
        profileImage: ImagePath.feedImage,
        type: UserNotificationType.follow,
      ),

      UserNotificationModel(
        id: '3',
        userName: 'zara_glamour',
        message: 'commented: YESSS this is everything! 🔥',
        time: '25m',
        profileImage: ImagePath.feedImage,
        postImage: ImagePath.feedImage,
        type: UserNotificationType.comment,
      ),

      UserNotificationModel(
        id: '4',
        userName: 'Omnia Nightclub',
        message: 'New event added — Martin Garrix this Saturday!',
        time: '1h',
        profileImage: '',
        type: UserNotificationType.event,
      ),

      UserNotificationModel(
        id: '5',
        userName: '',
        message:
            '🔥 Las Vegas Trip is going OFF right now! 3 events happening near you',
        time: '2h',
        profileImage: '',
        type: UserNotificationType.nearby,
        isRead: true,
      ),

      UserNotificationModel(
        id: '6',
        userName: '',
        message: '🎟️ Your ticket for ULTRA x Omnia is confirmed!',
        time: '3h',
        profileImage: '',
        type: UserNotificationType.ticket,
        isRead: true,
      ),
    ]);
  }
}
