class UserLineupModel {
  final String? id;
  final String name;
  final String role;
  final String image;

  const UserLineupModel({
    this.id,
    required this.name,
    required this.role,
    required this.image,
  });

  factory UserLineupModel.fromJson(Map<String, dynamic> json) {
    return UserLineupModel(
      id: json['id']?.toString(),
      name: json['artist_name']?.toString() ?? json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      image: json['artist_image']?.toString() ?? json['image']?.toString() ?? '',
    );
  }
}
