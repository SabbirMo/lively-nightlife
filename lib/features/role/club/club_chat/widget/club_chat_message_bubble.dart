import 'package:flutter/material.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_message_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/widget/user_chat_message_bubble.dart';

class ClubChatMessageBubble extends StatelessWidget {
  final UserMessageModel message;

  const ClubChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return UserChatMessageBubble(
      message: message,
      isClubView: true,
    );
  }
}
