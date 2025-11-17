class UserProfile {
  UserProfile({
    required this.uid,
    required this.email,
    this.name,
    this.deviceId,
    this.sharedWith = const [],
    this.sharedToMe = const [],
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      email: map['email'],
      name: map['name'],
      deviceId: map['deviceId'],
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      sharedToMe: List<String>.from(map['sharedToMe'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'deviceId': deviceId,
    'sharedWith': sharedWith,
    'sharedToMe': sharedToMe,
  };

  final String uid;
  final String email;
  final String? name;
  final String? deviceId;
  final List<String> sharedWith;
  final List<String> sharedToMe;
}
