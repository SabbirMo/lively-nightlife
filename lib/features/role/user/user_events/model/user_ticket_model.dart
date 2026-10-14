class UserTicketModel {
  final String id;
  final String name;
  final int price;
  final int available;
  final int total;

  const UserTicketModel({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
    required this.total,
  });

  UserTicketModel copyWith({
    String? id,
    String? name,
    int? price,
    int? available,
    int? total,
  }) {
    return UserTicketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      available: available ?? this.available,
      total: total ?? this.total,
    );
  }
}
