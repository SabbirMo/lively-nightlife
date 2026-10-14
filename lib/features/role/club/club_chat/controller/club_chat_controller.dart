import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';

class ClubChatController extends GetxController {
  final UserChatController _userChatController = Get.isRegistered<UserChatController>()
      ? Get.find<UserChatController>()
      : Get.put(UserChatController());

  TextEditingController get messageInputController => _userChatController.messageInputController;
  RxList<UserChatModel> get chatsList => _userChatController.chatsList;
  Rxn<UserChatModel> get activeChat => _userChatController.activeChat;

  void selectChat(UserChatModel chat) {
    _userChatController.selectChat(chat);
  }

  void sendMessage(String text, {bool sentByClub = true}) {
    _userChatController.sendMessage(text, sentByClub: sentByClub);
  }

  Future<void> pickFileAttachment({bool sentByClub = true}) async {
    await _userChatController.pickFileAttachment(sentByClub: sentByClub);
  }

  Future<void> pickImageAttachment(bool fromCamera, {bool sentByClub = true}) async {
    await _userChatController.pickImageAttachment(fromCamera, sentByClub: sentByClub);
  }
}
