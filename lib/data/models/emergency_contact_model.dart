// models/emergency_contact.dart

class EmergencyContact {
  final String name;
  final String number;
  final String description;
  final String icon; // 아이콘 이름 또는 이모지

  const EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.icon,
  });

  // 기본 응급 연락처들
  static const List<EmergencyContact> defaultContacts = [
    EmergencyContact(
      name: '119',
      number: '119',
      description: '소방서 (응급구조)',
      icon: '🚒',
    ),
    EmergencyContact(
      name: '산악구조대',
      number: '119',
      description: '산악 전문 구조대',
      icon: '⛰️',
    ),
    EmergencyContact(
      name: '국립공원관리공단',
      number: '1670-9201',
      description: '국립공원 안전신고',
      icon: '🏔️',
    ),
  ];
}
