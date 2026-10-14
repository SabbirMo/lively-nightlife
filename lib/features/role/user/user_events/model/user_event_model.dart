import 'package:get/get.dart';
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
  }) : isRsvped = isRsvped.obs;

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
    );
  }
}
