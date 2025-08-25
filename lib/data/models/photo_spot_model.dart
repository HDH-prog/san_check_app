// models/photo_spot.dart

class PhotoSpot {
  final String id;
  final String userId;
  final String userName;
  final String mountainId;
  final String mountainName;
  final String imageUrl;
  final String spotName; // 포토스팟 이름
  final String description; // 간단 설명
  final DateTime createdAt;
  final int likeCount;
  final List<String> likedUserIds; // 좋아요 누른 사용자들
  final int commentCount;

  PhotoSpot({
    required this.id,
    required this.userId,
    required this.userName,
    required this.mountainId,
    required this.mountainName,
    required this.imageUrl,
    required this.spotName,
    required this.description,
    required this.createdAt,
    this.likeCount = 0,
    this.likedUserIds = const [],
    this.commentCount = 0,
  });

  // 현재 사용자가 좋아요 했는지 확인
  bool isLikedBy(String userId) {
    return likedUserIds.contains(userId);
  }

  factory PhotoSpot.fromJson(Map<String, dynamic> json) {
    return PhotoSpot(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      mountainId: json['mountainId'],
      mountainName: json['mountainName'],
      imageUrl: json['imageUrl'],
      spotName: json['spotName'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'] ?? 0,
      likedUserIds: List<String>.from(json['likedUserIds'] ?? []),
      commentCount: json['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'mountainId': mountainId,
      'mountainName': mountainName,
      'imageUrl': imageUrl,
      'spotName': spotName,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'likedUserIds': likedUserIds,
      'commentCount': commentCount,
    };
  }
}
