import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'user_ticket_model.dart';
import 'user_lineup_model.dart';

class UserEventModel {
  final String id;
  final String name;
  final String location;
  final String date;
  final String time;
  final String duration;
  final String image;
  final int price;
  final List<String> categories;
  final String goingCount;
  final String interestedCount;
  final bool isHot;
  final RxBool isRsvped;
  final String description;
  final List<UserTicketModel> tickets;
  final List<UserLineupModel> lineup;
  final String venueId;
  final String venueName;
  final String? venueImage;
  final String dressCode;
  final String ageRestriction;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> tags;
  final bool isActive;
  final int rsvpCount;

  UserEventModel({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.duration,
    required this.image,
    required this.price,
    required this.categories,
    required this.goingCount,
    required this.interestedCount,
    required this.isHot,
    required bool isRsvped,
    required this.description,
    required this.tickets,
    required this.lineup,
    this.venueId = '',
    this.venueName = '',
    this.venueImage,
    this.dressCode = '',
    this.ageRestriction = '',
    this.startTime,
    this.endTime,
    this.tags = const [],
    this.isActive = true,
    this.rsvpCount = 0,
  }) : isRsvped = isRsvped.obs;

  factory UserEventModel.fromJson(Map<String, dynamic> json, {bool isHot = false}) {
    DateTime? parsedStart;
    if (json['start_time'] != null) {
      parsedStart = DateTime.tryParse(json['start_time'].toString());
    }

    DateTime? parsedEnd;
    if (json['end_time'] != null) {
      parsedEnd = DateTime.tryParse(json['end_time'].toString());
    }

    String formattedDate = '';
    String formattedTime = '';
    if (parsedStart != null) {
      final local = parsedStart.toLocal();
      formattedDate =
          '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
      final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
      final ampm = local.hour >= 12 ? 'PM' : 'AM';
      final min = local.minute.toString().padLeft(2, '0');
      formattedTime = '$hour:$min $ampm';
    } else {
      formattedDate = json['date']?.toString() ?? '';
      formattedTime = json['time']?.toString() ?? '';
    }

    String formattedDuration = '';
    if (parsedStart != null && parsedEnd != null) {
      final localEnd = parsedEnd.toLocal();
      final endHour = localEnd.hour % 12 == 0 ? 12 : localEnd.hour % 12;
      final endAmpm = localEnd.hour >= 12 ? 'PM' : 'AM';
      final endMin = localEnd.minute.toString().padLeft(2, '0');
      formattedDuration = '$formattedTime - $endHour:$endMin $endAmpm';
    } else {
      formattedDuration = json['duration']?.toString() ?? formattedTime;
    }

    String parsedImage =
        json['cover_image']?.toString() ?? json['image']?.toString() ?? '';
    if (parsedImage.isEmpty || parsedImage == 'null') {
      parsedImage = ImagePath.clubCoverPhoto;
    } else if (parsedImage.startsWith('/')) {
      parsedImage = '${ApiEndpoints.baseUrl}$parsedImage';
    }

    String? venueImg = json['venue_image']?.toString();
    if (venueImg != null && venueImg.isNotEmpty && venueImg.startsWith('/')) {
      venueImg = '${ApiEndpoints.baseUrl}$venueImg';
    }

    final venueName = json['venue_name']?.toString() ?? '';
    final customAddress = json['custom_venue_address']?.toString() ?? '';
    String parsedLocation = venueName.isNotEmpty
        ? (customAddress.isNotEmpty ? '$venueName, $customAddress' : venueName)
        : (customAddress.isNotEmpty
            ? customAddress
            : (json['location']?.toString() ?? ''));

    int parsedPrice = 0;
    final rawPrice = json['ticket_price'] ?? json['price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice.toInt();
    } else if (rawPrice is String) {
      parsedPrice = (double.tryParse(rawPrice) ?? 0).toInt();
    }

    List<UserTicketModel> ticketsList = [];
    final rawTickets = json['ticket_tiers'] ?? json['tickets'];
    if (rawTickets is List) {
      for (var t in rawTickets) {
        if (t is Map<String, dynamic>) {
          ticketsList.add(UserTicketModel.fromJson(t));
        }
      }
    }
    if (parsedPrice == 0 && ticketsList.isNotEmpty) {
      parsedPrice = ticketsList
          .map((t) => t.price)
          .reduce((a, b) => a < b ? a : b);
    }

    List<UserLineupModel> lineupList = [];
    final rawLineup = json['lineup'];
    if (rawLineup is List) {
      for (var l in rawLineup) {
        if (l is Map<String, dynamic>) {
          lineupList.add(UserLineupModel.fromJson(l));
        }
      }
    }

    List<String> categoriesList = [];
    final rawCategories = json['categories'];
    if (rawCategories is List) {
      for (var c in rawCategories) {
        if (c is Map && c['name'] != null) {
          categoriesList.add(c['name'].toString());
        } else if (c is String) {
          categoriesList.add(c);
        }
      }
    }

    List<String> tagsList = [];
    final rawTags = json['tags'];
    if (rawTags is List) {
      tagsList = rawTags.map((t) => t.toString()).toList();
    }

    final rsvpCount = (json['rsvp_count'] as num?)?.toInt() ?? 0;
    final goingCount = rsvpCount > 0
        ? rsvpCount.toString()
        : (json['goingCount']?.toString() ??
            json['going_count']?.toString() ??
            '0');
    final interestedCount = json['interestedCount']?.toString() ??
        json['interested_count']?.toString() ??
        '0';
    final isUserGoing = json['is_user_going'] == true ||
        json['is_rsvped'] == true ||
        json['isRsvped'] == true;

    return UserEventModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      location: parsedLocation,
      date: formattedDate,
      time: formattedTime,
      duration: formattedDuration,
      image: parsedImage,
      price: parsedPrice,
      categories: categoriesList,
      goingCount: goingCount,
      interestedCount: interestedCount,
      isHot: isHot || json['is_hot'] == true || json['isHot'] == true,
      isRsvped: isUserGoing,
      description: json['description']?.toString() ?? '',
      tickets: ticketsList,
      lineup: lineupList,
      venueId: json['venue']?.toString() ?? '',
      venueName: venueName,
      venueImage: venueImg,
      dressCode: json['dress_code']?.toString() ?? '',
      ageRestriction: json['age_restriction']?.toString() ?? '',
      startTime: parsedStart,
      endTime: parsedEnd,
      tags: tagsList,
      isActive: json['is_active'] != false,
      rsvpCount: rsvpCount,
    );
  }

  UserEventModel copyWith({
    String? id,
    String? name,
    String? location,
    String? date,
    String? time,
    String? duration,
    String? image,
    int? price,
    List<String>? categories,
    String? goingCount,
    String? interestedCount,
    bool? isHot,
    bool? isRsvped,
    String? description,
    List<UserTicketModel>? tickets,
    List<UserLineupModel>? lineup,
    String? venueId,
    String? venueName,
    String? venueImage,
    String? dressCode,
    String? ageRestriction,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? tags,
    bool? isActive,
    int? rsvpCount,
  }) {
    return UserEventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      image: image ?? this.image,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      goingCount: goingCount ?? this.goingCount,
      interestedCount: interestedCount ?? this.interestedCount,
      isHot: isHot ?? this.isHot,
      isRsvped: isRsvped ?? this.isRsvped.value,
      description: description ?? this.description,
      tickets: tickets ?? this.tickets,
      lineup: lineup ?? this.lineup,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      venueImage: venueImage ?? this.venueImage,
      dressCode: dressCode ?? this.dressCode,
      ageRestriction: ageRestriction ?? this.ageRestriction,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      rsvpCount: rsvpCount ?? this.rsvpCount,
    );
  }
}
