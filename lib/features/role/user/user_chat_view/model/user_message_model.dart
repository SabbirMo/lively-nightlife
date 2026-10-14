import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/model/user_discover_club_model.dart';

class UserMessageModel {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final String? imagePath;
  final String? filePath;
  final String? fileName;
  final String? fileSize;
  final UserDiscoverClubModel? sharedClubOrEvent;
  final bool sentByClub;

  const UserMessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.imagePath,
    this.filePath,
    this.fileName,
    this.fileSize,
    this.sharedClubOrEvent,
    this.sentByClub = false,
  });
}
