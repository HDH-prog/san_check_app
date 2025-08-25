// models/user.dart

class User {
  final String id;
  final String name;
  final String? profileImageUrl;
  final DateTime joinDate;
  final int totalHikingCount; // 총 등산 횟수
  final List<String> visitedMountainIds; // 방문한 산 ID 목록

  User({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.joinDate,
    this.totalHikingCount = 0,
    this.visitedMountainIds = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      joinDate: DateTime.parse(json['joinDate']),
      totalHikingCount: json['totalHikingCount'] ?? 0,
      visitedMountainIds: List<String>.from(json['visitedMountainIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'joinDate': joinDate.toIso8601String(),
      'totalHikingCount': totalHikingCount,
      'visitedMountainIds': visitedMountainIds,
    };
  }
}
