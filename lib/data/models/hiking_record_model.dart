// models/hiking_record.dart

class HikingRecord {
  final String id;
  final String userId;
  final String mountainId;
  final String mountainName; // 빠른 표시용
  final DateTime date;
  final List<String> photoUrls; // 사진 1-2장
  final String? memo; // 간단 메모
  final String season; // 봄/여름/가을/겨울
  final bool isCompleted; // 완등 여부

  HikingRecord({
    required this.id,
    required this.userId,
    required this.mountainId,
    required this.mountainName,
    required this.date,
    this.photoUrls = const [],
    this.memo,
    required this.season,
    this.isCompleted = true,
  });

  // 계절 자동 판단
  static String getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return '봄';
    if (month >= 6 && month <= 8) return '여름';
    if (month >= 9 && month <= 11) return '가을';
    return '겨울';
  }

  factory HikingRecord.fromJson(Map<String, dynamic> json) {
    return HikingRecord(
      id: json['id'],
      userId: json['userId'],
      mountainId: json['mountainId'],
      mountainName: json['mountainName'],
      date: DateTime.parse(json['date']),
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      memo: json['memo'],
      season: json['season'],
      isCompleted: json['isCompleted'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mountainId': mountainId,
      'mountainName': mountainName,
      'date': date.toIso8601String(),
      'photoUrls': photoUrls,
      'memo': memo,
      'season': season,
      'isCompleted': isCompleted,
    };
  }
}

// 산별 등산 통계 (깃발 표시용)
class MountainVisitSummary {
  final String mountainId;
  final String mountainName;
  final int visitCount; // 총 방문 횟수
  final List<String> visitedSeasons; // 방문한 계절들
  final DateTime? lastVisitDate;
  final bool hasAllSeasons; // 사계절 모두 방문했는지

  MountainVisitSummary({
    required this.mountainId,
    required this.mountainName,
    required this.visitCount,
    required this.visitedSeasons,
    this.lastVisitDate,
    required this.hasAllSeasons,
  });

  // 깃발 색상 결정 (UI에서 사용)
  String get flagLevel {
    if (hasAllSeasons) return 'gold'; // 사계절 완등
    if (visitCount >= 10) return 'silver'; // 10회 이상
    if (visitCount >= 5) return 'bronze'; // 5회 이상
    return 'basic'; // 기본
  }
}
