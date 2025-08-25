// screens/map/map_screen.dart

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../data/models/index.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 임시 데이터
  final List<Mountain> mountains = [
    Mountain(
      id: '1',
      name: '북한산',
      height: 836.5,
      latitude: 37.6589,
      longitude: 126.9770,
      location: '서울특별시',
      description: '서울의 진산',
      isTop100: true,
    ),
    Mountain(
      id: '2',
      name: '설악산',
      height: 1708,
      latitude: 38.1193,
      longitude: 128.4654,
      location: '강원도',
      description: '한국의 알프스',
      isTop100: true,
    ),
  ];

  final Map<String, MountainVisitSummary> visitSummaries = {
    '1': MountainVisitSummary(
      mountainId: '1',
      mountainName: '북한산',
      visitCount: 12,
      visitedSeasons: ['봄', '여름', '가을', '겨울'],
      hasAllSeasons: true,
      lastVisitDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('산책'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt),
            onPressed: _showAddRecordDialog,
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // 지도 영역 (실제로는 Google Maps나 Kakao Map 위젯)
          Container(
            color: AppColors.surfaceVariant,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: AppColors.textTertiary),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    '지도 영역',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Google Maps / Kakao Map 연동 필요',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 산 정보 카드
          Positioned(
            bottom: AppSpacing.xl,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: _buildMountainCard(),
          ),

          // 등산하기 버튼
          Positioned(
            bottom: 120,
            right: AppSpacing.lg,
            child: FloatingActionButton.extended(
              onPressed: _startHiking,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.hiking),
              label: const Text('등산하기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMountainCard() {
    final mountain = mountains[0]; // 선택된 산
    final visitSummary = visitSummaries[mountain.id];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 깃발 아이콘
              _buildFlagIcon(visitSummary),
              SizedBox(width: AppSpacing.md),

              // 산 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mountain.name, style: AppTypography.titleLarge),
                    Text(
                      '${mountain.height.toStringAsFixed(0)}m · ${mountain.location}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // 100대 명산 뱃지
              if (mountain.isTop100)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '100대 명산',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          if (visitSummary != null) ...[
            SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.border),
            SizedBox(height: AppSpacing.md),

            // 방문 기록
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('방문', '${visitSummary.visitCount}회'),
                _buildStatItem(
                  '마지막',
                  _getLastVisitText(visitSummary.lastVisitDate),
                ),
                _buildStatItem(
                  '계절',
                  _getSeasonsText(visitSummary.visitedSeasons),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),
            AppButton(
              text: '내 기록 보기',
              onPressed: _showMyRecords,
              variant: ButtonVariant.outline,
              size: ButtonSize.small,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFlagIcon(MountainVisitSummary? summary) {
    Color flagColor;
    IconData flagIcon;

    if (summary == null) {
      flagColor = AppColors.flagNotCompleted;
      flagIcon = Icons.flag_outlined;
    } else {
      switch (summary.flagLevel) {
        case 'gold':
          flagColor = AppColors.warning;
          flagIcon = Icons.flag;
          break;
        case 'silver':
          flagColor = AppColors.textSecondary;
          flagIcon = Icons.flag;
          break;
        case 'bronze':
          flagColor = Color(0xFFCD7F32);
          flagIcon = Icons.flag;
          break;
        default:
          flagColor = AppColors.flagCompleted;
          flagIcon = Icons.flag;
      }
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: flagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(flagIcon, color: flagColor, size: 28),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getLastVisitText(DateTime? date) {
    if (date == null) return '-';
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return '오늘';
    if (days == 1) return '어제';
    if (days < 7) return '$days일 전';
    if (days < 30) return '${(days / 7).floor()}주 전';
    return '${(days / 30).floor()}달 전';
  }

  String _getSeasonsText(List<String> seasons) {
    if (seasons.length == 4) return '사계절 🏆';
    if (seasons.isEmpty) return '-';
    return seasons.join(',');
  }

  void _showAddRecordDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => const AddRecordBottomSheet(),
    );
  }

  void _startHiking() {
    // 등산 시작 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('등산 모드를 시작합니다'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showMyRecords() {
    // 내 기록 보기
  }
}

// 등산 기록 추가 바텀시트
class AddRecordBottomSheet extends StatelessWidget {
  const AddRecordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text('등산 기록 추가', style: AppTypography.headlineMedium),
            SizedBox(height: AppSpacing.xl),

            // 산 선택
            MountainSearchBar(hintText: '산 이름을 검색하세요', onChanged: (value) {}),
            SizedBox(height: AppSpacing.lg),

            // 날짜 선택
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today, color: AppColors.primary),
              title: Text('날짜 선택'),
              subtitle: Text('2024년 3월 15일'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),

            // 사진 추가
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.photo_camera, color: AppColors.primary),
              title: Text('사진 추가'),
              subtitle: Text('최대 2장'),
              trailing: Icon(Icons.add_circle_outline),
              onTap: () {},
            ),

            SizedBox(height: AppSpacing.xl),

            // 저장 버튼
            AppButton(
              text: '기록 저장',
              onPressed: () => Navigator.pop(context),
              isFullWidth: true,
            ),

            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
