class UserTicketModel {
  final String id;
  final String name;
  final int price;
  final int available;
  final int total;
  final String? description;

  const UserTicketModel({
    required this.id,
    required this.name,
    required this.price,
    required this.available,
    required this.total,
    this.description,
  });

  factory UserTicketModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    int parsedPrice = 0;
    if (rawPrice is num) {
      parsedPrice = rawPrice.toInt();
    } else if (rawPrice is String) {
      parsedPrice = (double.tryParse(rawPrice) ?? 0).toInt();
    }

    return UserTicketModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: parsedPrice,
      available: (json['available_quantity'] as num?)?.toInt() ??
          (json['available'] as num?)?.toInt() ??
          0,
      total: (json['total_quantity'] as num?)?.toInt() ??
          (json['total'] as num?)?.toInt() ??
          0,
      description: json['description']?.toString(),
    );
  }

  UserTicketModel copyWith({
    String? id,
    String? name,
    int? price,
    int? available,
    int? total,
    String? description,
  }) {
    return UserTicketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      available: available ?? this.available,
      total: total ?? this.total,
      description: description ?? this.description,
    );
  }
}
