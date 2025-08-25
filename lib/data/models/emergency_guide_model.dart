// models/emergency_guide.dart

class EmergencyGuide {
  final String id;
  final String title;
  final String situation; // 상황 설명
  final List<String> steps; // 응급처치 단계별 가이드
  final String warning; // 주의사항

  const EmergencyGuide({
    required this.id,
    required this.title,
    required this.situation,
    required this.steps,
    required this.warning,
  });

  // 기본 응급처치 가이드들
  static const List<EmergencyGuide> defaultGuides = [
    EmergencyGuide(
      id: '1',
      title: '발목 염좌',
      situation: '발목을 삐었을 때',
      steps: [
        '즉시 활동을 중단하고 안전한 곳으로 이동',
        '발목을 심장보다 높게 올려 부기 감소',
        '차가운 물이나 얼음으로 15-20분간 냉찜질',
        '압박붕대로 고정 (너무 꽉 조이지 않게)',
        '무리하지 말고 하산',
      ],
      warning: '뼈가 부러진 것 같으면 절대 움직이지 말고 119 신고',
    ),
    EmergencyGuide(
      id: '2',
      title: '탈수 증상',
      situation: '어지럽고 목이 마를 때',
      steps: [
        '그늘진 곳으로 즉시 이동',
        '조금씩 자주 물 섭취 (한 번에 많이 X)',
        '염분 보충 (스포츠음료, 소금)',
        '젖은 수건으로 목과 손목 냉각',
        '증상이 심하면 즉시 하산',
      ],
      warning: '의식이 흐려지면 즉시 119 신고',
    ),
    EmergencyGuide(
      id: '3',
      title: '벌 쏘임',
      situation: '벌에 쏘였을 때',
      steps: [
        '침이 있으면 신용카드 등으로 긁어내기',
        '비누와 물로 깨끗이 씻기',
        '차가운 물이나 얼음으로 냉찜질',
        '항히스타민제 복용 (있는 경우)',
        '증상 관찰하며 하산',
      ],
      warning: '호흡곤란, 전신 두드러기 발생 시 즉시 119 신고 (아나필락시스)',
    ),
    EmergencyGuide(
      id: '4',
      title: '저체온증',
      situation: '몸이 떨리고 추울 때',
      steps: [
        '바람 막이가 되는 곳으로 이동',
        '젖은 옷은 갈아입기',
        '따뜻한 음료 섭취 (술 제외)',
        '담요나 옷으로 몸 감싸기',
        '체온 회복 후 즉시 하산',
      ],
      warning: '의식이 흐려지거나 떨림이 멈추면 위험 신호, 즉시 119 신고',
    ),
    EmergencyGuide(
      id: '5',
      title: '미끄러짐 사고',
      situation: '미끄러져 다쳤을 때',
      steps: [
        '무리하게 일어나지 말고 부상 확인',
        '출혈이 있으면 깨끗한 천으로 압박',
        '골절 의심 시 부목 고정',
        '통증 부위 냉찜질',
        '안전하게 하산 또는 구조 요청',
      ],
      warning: '머리를 다쳤거나 의식이 흐려지면 즉시 119 신고',
    ),
  ];
}

// models/gps_location.dart

class GpsLocation {
  final double latitude;
  final double longitude;
  final double? altitude; // 고도
  final DateTime timestamp;
  final double? accuracy; // 정확도 (미터)

  GpsLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    required this.timestamp,
    this.accuracy,
  });

  // DMS (도분초) 형식으로 변환
  String toDMS() {
    String latDirection = latitude >= 0 ? 'N' : 'S';
    String lonDirection = longitude >= 0 ? 'E' : 'W';

    var lat = latitude.abs();
    var lon = longitude.abs();

    int latDegrees = lat.floor();
    int latMinutes = ((lat - latDegrees) * 60).floor();
    double latSeconds = ((lat - latDegrees - latMinutes / 60) * 3600);

    int lonDegrees = lon.floor();
    int lonMinutes = ((lon - lonDegrees) * 60).floor();
    double lonSeconds = ((lon - lonDegrees - lonMinutes / 60) * 3600);

    return '$latDegrees°$latMinutes\'${latSeconds.toStringAsFixed(1)}\"$latDirection, '
        '$lonDegrees°$lonMinutes\'${lonSeconds.toStringAsFixed(1)}\"$lonDirection';
  }

  // 간단한 좌표 표시
  String toSimpleString() {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
}
