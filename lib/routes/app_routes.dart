import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/bindings/auth_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/bindings/opt_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/bindings/reset_password_flow_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/bindings/signup_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/get_started_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/login_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/otp_verification_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/password_reset_flow_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/sign_up_view.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/bindings/club_bottom_navbar_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/bindings/user_bottom_navbar_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/view/club_bottom_navbar_view.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/view/user_bottom_navigation_bar_view.dart';
// import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/bindings/navbar_bindings.dart';
// import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/view/bottom_navigation_bar_view.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/bindings/onboading_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/bindings/permissions_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/bindings/vibe_selection_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/model/permission_type.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/view/onboarding_view.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/view/permission_view.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/view/vibe_selection_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/bindings/heat_map_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/bindings/user_notification_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/view/user_notification_read_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/view/user_notification_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/bindings/user_chat_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/view/user_chat_screen_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_club_details/bindings/user_club_details_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_club_details/view/user_club_details_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/bindings/user_discover_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/bindings/user_event_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/view/user_event_details_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/bindings/user_home_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/splash_view/bindings/splash_bindings.dart';
import 'package:lively_nightlife_nightclub_party/features/splash_view/view/splash_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/bindings/user_profile_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/view/user_profile_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/view/user_followers_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/view/user_following_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile/view/user_other_profile_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_profile/bindings/club_profile_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_profile/view/club_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_profile/view/club_notifications_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_profile/view/club_account_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_profile/view/club_privacy_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/bindings/user_profile_setting_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/user_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/user_notifications_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/user_account_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/user_privacy_settings_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/bindings/edit_profile_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/edit_profile_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/bindings/change_password_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/change_password_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/bindings/change_email_binding.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/view/change_email_view.dart';

class AppRoute {
  static const String splashView = '/splashView';
  static const String onboardingView = '/onboardingView';
  static const String loginView = '/loginView';
  static const String forgetPassView = '/forgetPassView';
  static const String createNewPassView = '/createNewPassView';
  static const String signUpView = '/signUpView';
  static const String userBottomNavigationBarView =
      '/userBottomNavigationBarView';
  static const String clubBottomNavbarView = '/clubBottomNavbarView';
  static const String notificationView = '/notificationView';
  static const String changePasswordView = '/changePasswordView';
  static const String changeEmailView = '/changeEmailView';
  static const String getStartedView = '/getstartedView';
  static const String otpVerificationView = '/otpVerificationView';
  static const String permissionView = '/permissionView';
  static const String vibeSelectionView = '/vibeSelectionView';
  static const String userNotificationView = '/userNotificationView';
  static const String userNotificationReadView = '/userNotificationReadView';
  static const String userClubDetailsView = '/userClubDetailsView';
  static const String userChatScreenView = '/userChatScreenView';
  static const String userEventDetailsView = '/userEventDetailsView';
  static const String userProfileView = '/userProfileView';
  static const String userFollowersView = '/userFollowersView';
  static const String userFollowingView = '/userFollowingView';
  static const String userOtherProfileView = '/userOtherProfileView';
  static const String clubSettingsView = '/clubSettingsView';
  static const String clubNotificationsSettingsView =
      '/clubNotificationsSettingsView';
  static const String clubAccountSettingsView = '/clubAccountSettingsView';
  static const String clubPrivacySettingsView = '/clubPrivacySettingsView';
  static const String userSettingsView = '/userSettingsView';
  static const String userNotificationsSettingsView =
      '/userNotificationsSettingsView';
  static const String userAccountSettingsView = '/userAccountSettingsView';
  static const String userPrivacySettingsView = '/userPrivacySettingsView';
  static const String editProfileView = '/editProfileView';

  static String getSplashView() => splashView;
  static String getOnboardingView() => onboardingView;
  static String getLoginView() => loginView;
  static String getForgetPassView() => forgetPassView;
  static String getCreateNewPassView() => createNewPassView;
  static String getSignUpView() => signUpView;
  static String getUserBottomNavigationBarView() => userBottomNavigationBarView;
  static String getClubBottomNavbarView() => clubBottomNavbarView;
  static String getNotificationView() => notificationView;
  static String getChangePasswordView() => changePasswordView;
  static String getChangeEmailView() => changeEmailView;
  static String getGetStartedView() => getStartedView;
  static String getOtpVerificationView() => otpVerificationView;
  static String getPermissionView() => permissionView;
  static String getVibeSelectionView() => vibeSelectionView;
  static String getUserNotificationView() => userNotificationView;
  static String getUserNotificationReadView() => userNotificationReadView;
  static String getUserClubDetailsView() => userClubDetailsView;
  static String getUserChatScreenView() => userChatScreenView;
  static String getUserEventDetailsView() => userEventDetailsView;
  static String getUserProfileView() => userProfileView;
  static String getUserFollowersView() => userFollowersView;
  static String getUserFollowingView() => userFollowingView;
  static String getUserOtherProfileView() => userOtherProfileView;
  static String getClubSettingsView() => clubSettingsView;
  static String getClubNotificationsSettingsView() =>
      clubNotificationsSettingsView;
  static String getClubAccountSettingsView() => clubAccountSettingsView;
  static String getClubPrivacySettingsView() => clubPrivacySettingsView;
  static String getUserSettingsView() => userSettingsView;
  static String getUserNotificationsSettingsView() =>
      userNotificationsSettingsView;
  static String getUserAccountSettingsView() => userAccountSettingsView;
  static String getUserPrivacySettingsView() => userPrivacySettingsView;
  static String getEditProfileView() => editProfileView;

  static List<GetPage> routes = [
    GetPage(
      name: splashView,
      page: () => SplashView(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: onboardingView,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: loginView, page: () => LoginView(), binding: AuthBindings()),
    GetPage(
      name: forgetPassView,
      page: () => PasswordResetFlowView(),
      binding: ResetPasswordFlowBinding(),
    ),
    GetPage(
      name: createNewPassView,
      page: () => PasswordResetFlowView(),
      binding: ResetPasswordFlowBinding(),
    ),
    GetPage(
      name: signUpView,
      page: () => SignUpView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: userBottomNavigationBarView,
      page: () => UserBottomNavigationView(),
      bindings: [
        UserBottomNavbarBindings(),
        UserHomeBindings(),
        HeatMapBinding(),
        UserDiscoverBinding(),
      ],
    ),

    GetPage(
      name: clubBottomNavbarView,
      page: () => ClubBottomNavbarView(),
      binding: ClubBottomNavbarBinding(),
    ),
    // GetPage(
    //   name: notificationView,
    //   page: () => const NotificationView(),
    //   binding: NotificationBinding(),
    // ),
    GetPage(
      name: changePasswordView,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: changeEmailView,
      page: () => const ChangeEmailView(),
      binding: ChangeEmailBinding(),
    ),
    GetPage(name: getStartedView, page: () => GetStartedView()),
    GetPage(
      name: otpVerificationView,
      page: () => OtpVerificationView(),
      binding: OtpBinding(),
    ),

    GetPage(
      name: permissionView,
      page: () => const PermissionView(type: PermissionType.location),
      binding: PermissionsBinding(),
    ),

    GetPage(
      name: vibeSelectionView,
      page: () => const VibeSelectionView(),
      binding: VibeSelectionBinding(),
    ),
    GetPage(
      name: userNotificationView,
      page: () => const UserNotificationView(),
      binding: UserNotificationBinding(),
    ),
    GetPage(
      name: userNotificationReadView,
      page: () => const UserNotificationReadView(),
      // binding: UserNotificationBinding(),
    ),
    GetPage(
      name: userClubDetailsView,
      page: () => const UserClubDetailsView(),
      binding: UserClubDetailsBinding(),
    ),
    GetPage(
      name: userChatScreenView,
      page: () => const UserChatScreenView(),
      binding: UserChatBinding(),
    ),
    GetPage(
      name: userEventDetailsView,
      page: () => const UserEventDetailsView(),
      binding: UserEventBinding(),
    ),
    GetPage(
      name: userProfileView,
      page: () => const UserProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: userFollowersView,
      page: () => const UserFollowersView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: userFollowingView,
      page: () => const UserFollowingView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: userOtherProfileView,
      page: () => const UserOtherProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: clubSettingsView,
      page: () => const ClubSettingsView(),
      binding: ClubProfileBinding(),
    ),
    GetPage(
      name: clubNotificationsSettingsView,
      page: () => const ClubNotificationsSettingsView(),
      binding: ClubProfileBinding(),
    ),
    GetPage(
      name: clubAccountSettingsView,
      page: () => const ClubAccountSettingsView(),
      binding: ClubProfileBinding(),
    ),
    GetPage(
      name: clubPrivacySettingsView,
      page: () => const ClubPrivacySettingsView(),
      binding: ClubProfileBinding(),
    ),
    GetPage(
      name: userSettingsView,
      page: () => const UserSettingsView(),
      binding: UserProfileSettingBinding(),
    ),
    GetPage(
      name: userNotificationsSettingsView,
      page: () => const UserNotificationsSettingsView(),
      binding: UserProfileSettingBinding(),
    ),
    GetPage(
      name: userAccountSettingsView,
      page: () => const UserAccountSettingsView(),
      binding: UserProfileSettingBinding(),
    ),
    GetPage(
      name: userPrivacySettingsView,
      page: () => const UserPrivacySettingsView(),
      binding: UserProfileSettingBinding(),
    ),
    GetPage(
      name: editProfileView,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
