import 'package:get/get.dart';

class PasswordController extends GetxController {
  final password = ''.obs;
  final confirmPassword = ''.obs;
  void onPasswordChanged(String value) {
    password.value = value;
  }

  void onConfirmPasswordChanged(String value) {
    confirmPassword.value = value;
  }
}
