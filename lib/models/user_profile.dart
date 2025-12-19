/// UserProfile model for storing user information
class UserProfile {
  String name;
  String registrationNumber;
  String? profileImagePath;

  UserProfile({
    required this.name,
    required this.registrationNumber,
    this.profileImagePath,
  });

  /// Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'registrationNumber': registrationNumber,
      'profileImagePath': profileImagePath,
    };
  }

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      registrationNumber: json['registrationNumber'] as String,
      profileImagePath: json['profileImagePath'] as String?,
    );
  }

  /// Create a copy of UserProfile with updated fields
  UserProfile copyWith({
    String? name,
    String? registrationNumber,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
