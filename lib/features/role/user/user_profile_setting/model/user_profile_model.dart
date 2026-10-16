class UserProfileModel {
  final String? id;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? bio;
  final String? profileImage;
  final String? coverImage;
  final String? locationName;
  final int? followersCount;
  final int? followingCount;
  final int? postCount;
  final int? eventsCount;
  final dynamic lat;
  final dynamic lng;
  final String? registrationType;
  final bool? isUserProfileActive;

  UserProfileModel({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.dob,
    this.bio,
    this.profileImage,
    this.coverImage,
    this.locationName,
    this.followersCount,
    this.followingCount,
    this.postCount,
    this.eventsCount,
    this.lat,
    this.lng,
    this.registrationType,
    this.isUserProfileActive,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dob: json['dob'],
      bio: json['bio'],
      profileImage: json['profile_image'],
      coverImage: json['cover_image'],
      locationName: json['location_name'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      postCount: json['post_count'],
      eventsCount: json['events_count'],
      lat: json['lat'],
      lng: json['lng'],
      registrationType: json['registration_type'],
      isUserProfileActive: json['is_user_profile_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'bio': bio,
      'profile_image': profileImage,
      'cover_image': coverImage,
      'location_name': locationName,
      'followers_count': followersCount,
      'following_count': followingCount,
      'post_count': postCount,
      'events_count': eventsCount,
      'lat': lat,
      'lng': lng,
      'registration_type': registrationType,
      'is_user_profile_active': isUserProfileActive,
    };
  }
}
