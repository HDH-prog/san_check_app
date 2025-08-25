// models/mountain.dart

class Mountain {
  final String id;
  final String name;
  final double height; // 높이 (m)
  final double latitude;
  final double longitude;
  final String location; // 지역 (예: 강원도 평창군)
  final String description; // 간단 소개
  final bool isTop100; // 100대 명산 여부
  final List<String> seasons; // 추천 계절
  final String? imageUrl; // 대표 이미지

  Mountain({
    required this.id,
    required this.name,
    required this.height,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.description,
    this.isTop100 = false,
    this.seasons = const [],
    this.imageUrl,
  });

  // JSON 변환
  factory Mountain.fromJson(Map<String, dynamic> json) {
    return Mountain(
      id: json['id'],
      name: json['name'],
      height: json['height'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      location: json['location'],
      description: json['description'],
      isTop100: json['isTop100'] ?? false,
      seasons: List<String>.from(json['seasons'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'description': description,
      'isTop100': isTop100,
      'seasons': seasons,
      'imageUrl': imageUrl,
    };
  }
}
