import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends GetxController {

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    return status.isGranted;
  }
}