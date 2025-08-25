// models/hiking_session.dart

class HikingSession {
  final String id;
  final String mountainId;
  final String mountainName;
  final String? trailId; // 선택한 등산로
  final DateTime startTime;
  DateTime? endTime;
  final List<GpsPoint> gpsTrack; // GPS 트래킹 포인트들
  final List<PhotoPoint> photoPoints; // 사진 찍은 위치들
  double totalDistance; // 총 이동거리 (km)
  double totalElevationGain; // 총 상승고도 (m)
  int duration; // 소요시간 (분)
  bool isActive; // 현재 진행중인지

  HikingSession({
    required this.id,
    required this.mountainId,
    required this.mountainName,
    this.trailId,
    required this.startTime,
    this.endTime,
    this.gpsTrack = const [],
    this.photoPoints = const [],
    this.totalDistance = 0,
    this.totalElevationGain = 0,
    this.duration = 0,
    this.isActive = true,
  });

  // 현재 진행 시간 계산
  int getCurrentDuration() {
    if (isActive) {
      return DateTime.now().difference(startTime).inMinutes;
    }
    return duration;
  }

  // 포토스팟 근처인지 확인 (미터 단위)
  bool isNearPhotoSpot(double lat, double lon, double thresholdMeters) {
    // 간단한 거리 계산 로직
    // 실제로는 더 정확한 거리 계산 알고리즘 사용
    return false; // 구현 필요
  }

  factory HikingSession.fromJson(Map<String, dynamic> json) {
    return HikingSession(
      id: json['id'],
      mountainId: json['mountainId'],
      mountainName: json['mountainName'],
      trailId: json['trailId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      gpsTrack:
          (json['gpsTrack'] as List?)
              ?.map((e) => GpsPoint.fromJson(e))
              .toList() ??
          [],
      photoPoints:
          (json['photoPoints'] as List?)
              ?.map((e) => PhotoPoint.fromJson(e))
              .toList() ??
          [],
      totalDistance: json['totalDistance']?.toDouble() ?? 0,
      totalElevationGain: json['totalElevationGain']?.toDouble() ?? 0,
      duration: json['duration'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mountainId': mountainId,
      'mountainName': mountainName,
      'trailId': trailId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'gpsTrack': gpsTrack.map((e) => e.toJson()).toList(),
      'photoPoints': photoPoints.map((e) => e.toJson()).toList(),
      'totalDistance': totalDistance,
      'totalElevationGain': totalElevationGain,
      'duration': duration,
      'isActive': isActive,
    };
  }
}

// GPS 트래킹 포인트
class GpsPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final DateTime timestamp;

  GpsPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.timestamp,
  });

  factory GpsPoint.fromJson(Map<String, dynamic> json) {
    return GpsPoint(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      altitude: json['altitude'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// 사진 촬영 포인트
class PhotoPoint {
  final double latitude;
  final double longitude;
  final String photoUrl;
  final DateTime timestamp;
  final String? description;

  PhotoPoint({
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
    required this.timestamp,
    this.description,
  });

  factory PhotoPoint.fromJson(Map<String, dynamic> json) {
    return PhotoPoint(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      photoUrl: json['photoUrl'],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'photoUrl': photoUrl,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }
}
