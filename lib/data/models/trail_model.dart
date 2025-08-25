// models/trail.dart

enum TrailDifficulty { easy, medium, hard }

class Trail {
  final String id;
  final String mountainId; // 연결된 산 ID
  final String name; // 코스 이름 (예: "성삼재 코스")
  final double distance; // 거리 (km)
  final int estimatedTime; // 예상 소요시간 (분)
  final TrailDifficulty difficulty;
  final String description; // 코스 설명
  final List<PhotoSpotLocation> photoSpots; // 포토스팟 위치들

  Trail({
    required this.id,
    required this.mountainId,
    required this.name,
    required this.distance,
    required this.estimatedTime,
    required this.difficulty,
    required this.description,
    this.photoSpots = const [],
  });

  String get difficultyText {
    switch (difficulty) {
      case TrailDifficulty.easy:
        return '쉬움';
      case TrailDifficulty.medium:
        return '보통';
      case TrailDifficulty.hard:
        return '어려움';
    }
  }

  factory Trail.fromJson(Map<String, dynamic> json) {
    return Trail(
      id: json['id'],
      mountainId: json['mountainId'],
      name: json['name'],
      distance: json['distance'].toDouble(),
      estimatedTime: json['estimatedTime'],
      difficulty: TrailDifficulty.values[json['difficulty']],
      description: json['description'],
      photoSpots:
          (json['photoSpots'] as List?)
              ?.map((e) => PhotoSpotLocation.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mountainId': mountainId,
      'name': name,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'difficulty': difficulty.index,
      'description': description,
      'photoSpots': photoSpots.map((e) => e.toJson()).toList(),
    };
  }
}

// 포토스팟 위치 정보 (등산로 안내용)
class PhotoSpotLocation {
  final double latitude;
  final double longitude;
  final String name;
  final String description;

  PhotoSpotLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
  });

  factory PhotoSpotLocation.fromJson(Map<String, dynamic> json) {
    return PhotoSpotLocation(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'description': description,
    };
  }
}
