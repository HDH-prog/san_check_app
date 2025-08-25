// screens/safety/safety_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/design_system/design_system.dart';
import '../../data/models/index.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  GpsLocation? currentLocation;
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    setState(() {
      isLoadingLocation = true;
      // 임시 GPS 좌표 (실제로는 location 패키지 사용)
      currentLocation = GpsLocation(
        latitude: 37.5665,
        longitude: 126.9780,
        altitude: 42.3,
        timestamp: DateTime.now(),
        accuracy: 5.0,
      );
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('안전'), centerTitle: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 응급 신고 버튼
            _buildEmergencySection(),

            SizedBox(height: AppSpacing.xxl),

            // 현재 위치
            _buildLocationSection(),

            SizedBox(height: AppSpacing.xxl),

            // 긴급 연락처
            _buildEmergencyContactsSection(),

            SizedBox(height: AppSpacing.xxl),

            // 응급처치 가이드
            _buildEmergencyGuidesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySection() {
    return AppCard(
      backgroundColor: AppColors.error.withOpacity(0.05),
      border: Border.all(color: AppColors.error.withOpacity(0.2)),
      child: Column(
        children: [
          Icon(Icons.emergency, size: 48, color: AppColors.error),
          SizedBox(height: AppSpacing.lg),
          Text(
            '응급 상황 발생 시',
            style: AppTypography.titleLarge.copyWith(color: AppColors.error),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '아래 버튼을 눌러 119에 신고하세요',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          AppButton.emergency(
            text: '긴급 신고',
            onPressed: _showEmergencyDialog,
            icon: Icon(Icons.phone_in_talk),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.my_location, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Text('현재 위치', style: AppTypography.titleMedium),
              Spacer(),
              if (isLoadingLocation)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.refresh, size: 20),
                  onPressed: _getCurrentLocation,
                  color: AppColors.primary,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          if (currentLocation != null) ...[
            _buildLocationRow(
              'GPS 좌표',
              currentLocation!.toSimpleString(),
              canCopy: true,
            ),
            SizedBox(height: AppSpacing.sm),
            _buildLocationRow(
              'DMS 형식',
              currentLocation!.toDMS(),
              canCopy: true,
            ),
            if (currentLocation!.altitude != null) ...[
              SizedBox(height: AppSpacing.sm),
              _buildLocationRow(
                '고도',
                '${currentLocation!.altitude!.toStringAsFixed(1)}m',
              ),
            ],
            if (currentLocation!.accuracy != null) ...[
              SizedBox(height: AppSpacing.sm),
              _buildLocationRow(
                '정확도',
                '±${currentLocation!.accuracy!.toStringAsFixed(0)}m',
              ),
            ],
          ] else ...[
            Center(
              child: Text(
                '위치를 가져올 수 없습니다',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationRow(String label, String value, {bool canCopy = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (canCopy) ...[
              SizedBox(width: AppSpacing.sm),
              InkWell(
                onTap: () {
                  // 클립보드에 복사
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('위치가 복사되었습니다'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Icon(Icons.copy, size: 16, color: AppColors.primary),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('긴급 연락처', style: AppTypography.titleLarge),
        SizedBox(height: AppSpacing.md),
        ...EmergencyContact.defaultContacts.map((contact) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildContactCard(contact),
          );
        }),
      ],
    );
  }

  Widget _buildContactCard(EmergencyContact contact) {
    return AppCard(
      onTap: () => _makeCall(contact.number),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(contact.icon, style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: AppTypography.labelLarge),
                Text(
                  contact.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                contact.number,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.phone, size: 16, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyGuidesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('응급처치 가이드', style: AppTypography.titleLarge),
        SizedBox(height: AppSpacing.md),
        ...EmergencyGuide.defaultGuides.map((guide) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _buildGuideCard(guide),
          );
        }),
      ],
    );
  }

  Widget _buildGuideCard(EmergencyGuide guide) {
    return AppCard(
      onTap: () => _showGuideDetail(guide),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              Icons.medical_services,
              color: AppColors.warning,
              size: 20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guide.title, style: AppTypography.labelLarge),
                Text(
                  guide.situation,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmergencyCallDialog(),
    );
  }

  void _makeCall(String number) {
    // 전화 걸기 (실제로는 url_launcher 패키지 사용)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$number로 전화를 연결합니다'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showGuideDetail(EmergencyGuide guide) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => EmergencyGuideBottomSheet(guide: guide),
    );
  }
}

// 응급 신고 다이얼로그
class EmergencyCallDialog extends StatefulWidget {
  const EmergencyCallDialog({super.key});

  @override
  State<EmergencyCallDialog> createState() => _EmergencyCallDialogState();
}

class _EmergencyCallDialogState extends State<EmergencyCallDialog> {
  int countdown = 3;
  Timer? timer;
  bool isConfirmed = false;

  void startCountdown() {
    setState(() {
      isConfirmed = true;
      countdown = 3;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown == 0) {
          timer.cancel();
          // 119 전화 연결
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('119로 연결합니다'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emergency, size: 64, color: AppColors.error),
          SizedBox(height: AppSpacing.lg),
          Text(
            isConfirmed ? '119 연결 중...' : '응급 상황입니까?',
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          if (isConfirmed) ...[
            Text(
              countdown.toString(),
              style: AppTypography.displayLarge.copyWith(
                color: AppColors.error,
                fontSize: 48,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              '취소하려면 버튼을 누르세요',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            Text(
              '확인을 누르면 3초 후 119로 연결됩니다',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: [
        if (!isConfirmed) ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          AppButton(
            text: '확인',
            onPressed: startCountdown,
            variant: ButtonVariant.danger,
            size: ButtonSize.small,
          ),
        ] else ...[
          AppButton(
            text: '취소',
            onPressed: () {
              timer?.cancel();
              Navigator.pop(context);
            },
            variant: ButtonVariant.outline,
            isFullWidth: true,
          ),
        ],
      ],
    );
  }
}

// 응급처치 가이드 상세 바텀시트
class EmergencyGuideBottomSheet extends StatelessWidget {
  final EmergencyGuide guide;

  const EmergencyGuideBottomSheet({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // 제목
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: AppColors.warning,
                      size: 28,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guide.title,
                            style: AppTypography.headlineMedium,
                          ),
                          Text(
                            guide.situation,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xl),

                // 경고
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: AppColors.error, size: 20),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '주의사항',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              guide.warning,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // 단계별 가이드
                Text('응급처치 단계', style: AppTypography.titleLarge),
                SizedBox(height: AppSpacing.lg),

                ...guide.steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            step,
                            style: AppTypography.bodyMedium.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: AppSpacing.xl),

                // 119 연결 버튼
                AppButton(
                  text: '119 연결하기',
                  onPressed: () {
                    Navigator.pop(context);
                    // 119 연결
                  },
                  variant: ButtonVariant.danger,
                  isFullWidth: true,
                  icon: Icon(Icons.phone),
                ),

                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}
