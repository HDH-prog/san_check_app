// screens/mountain/mountain_info_screen.dart

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../data/models/index.dart';

class MountainInfoScreen extends StatefulWidget {
  const MountainInfoScreen({super.key});

  @override
  State<MountainInfoScreen> createState() => _MountainInfoScreenState();
}

class _MountainInfoScreenState extends State<MountainInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 임시 데이터
  final List<Mountain> allMountains = [
    Mountain(
      id: '1',
      name: '북한산',
      height: 836.5,
      latitude: 37.6589,
      longitude: 126.9770,
      location: '서울특별시 도봉구',
      description: '서울의 진산으로 불리는 북한산은 거대한 화강암 봉우리들이 장관을 이루는 산입니다.',
      isTop100: true,
    ),
    Mountain(
      id: '2',
      name: '설악산',
      height: 1708,
      latitude: 38.1193,
      longitude: 128.4654,
      location: '강원도 속초시',
      description: '한국의 알프스라 불리는 설악산은 사계절 아름다운 풍경을 자랑합니다.',
      isTop100: true,
    ),
    Mountain(
      id: '3',
      name: '한라산',
      height: 1947.3,
      latitude: 33.3617,
      longitude: 126.5292,
      location: '제주특별자치도',
      description: '대한민국 최고봉으로 제주도의 상징적인 산입니다.',
      isTop100: true,
    ),
    Mountain(
      id: '4',
      name: '지리산',
      height: 1915,
      latitude: 35.3373,
      longitude: 127.7306,
      location: '전라남도/경상남도',
      description: '민족의 영산으로 불리며 광활한 산악지대를 자랑합니다.',
      isTop100: true,
    ),
  ];

  List<Mountain> get filteredMountains {
    if (_searchQuery.isEmpty) return allMountains;
    return allMountains
        .where((m) => m.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('산 정보'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: MountainSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              onClear: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
          ),
        ),
      ),
      body: filteredMountains.isEmpty
          ? SearchEmptyState(title: '검색 결과가 없습니다', subtitle: '다른 산 이름으로 검색해보세요')
          : ListView.separated(
              padding: EdgeInsets.all(AppSpacing.lg),
              itemCount: filteredMountains.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final mountain = filteredMountains[index];
                return MountainInfoCard(
                  name: mountain.name,
                  height: '${mountain.height.toStringAsFixed(0)}m',
                  location: mountain.location,
                  difficulty: _getDifficulty(mountain.height),
                  onTap: () => _showMountainDetail(mountain),
                );
              },
            ),
    );
  }

  String _getDifficulty(double height) {
    if (height < 500) return '쉬움';
    if (height < 1000) return '보통';
    return '어려움';
  }

  void _showMountainDetail(Mountain mountain) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MountainDetailScreen(mountain: mountain),
      ),
    );
  }
}

// 산 상세 정보 화면
class MountainDetailScreen extends StatelessWidget {
  final Mountain mountain;

  const MountainDetailScreen({super.key, required this.mountain});

  @override
  Widget build(BuildContext context) {
    // 임시 등산로 데이터
    final trails = [
      Trail(
        id: '1',
        mountainId: mountain.id,
        name: '백운대 코스',
        distance: 3.4,
        estimatedTime: 180,
        difficulty: TrailDifficulty.hard,
        description: '북한산의 정상인 백운대까지 오르는 대표 코스입니다.',
      ),
      Trail(
        id: '2',
        mountainId: mountain.id,
        name: '대남문 코스',
        distance: 5.8,
        estimatedTime: 240,
        difficulty: TrailDifficulty.medium,
        description: '북한산성을 거쳐 대남문으로 가는 역사 탐방 코스입니다.',
      ),
      Trail(
        id: '3',
        mountainId: mountain.id,
        name: '둘레길 코스',
        distance: 7.2,
        estimatedTime: 150,
        difficulty: TrailDifficulty.easy,
        description: '산 아래를 따라 걷는 편안한 둘레길 코스입니다.',
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 앱바 with 이미지
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mountain.name,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.7),
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.landscape,
                    size: 80,
                    color: AppColors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // 기본 정보
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 주요 정보 카드
                  AppCard(
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.height,
                          '높이',
                          '${mountain.height.toStringAsFixed(0)}m',
                        ),
                        Divider(height: AppSpacing.xl),
                        _buildInfoRow(
                          Icons.location_on,
                          '위치',
                          mountain.location,
                        ),
                        if (mountain.isTop100) ...[
                          Divider(height: AppSpacing.xl),
                          _buildInfoRow(
                            Icons.star,
                            '등급',
                            '100대 명산',
                            valueColor: AppColors.accent,
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // 설명
                  Text('소개', style: AppTypography.titleLarge),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    mountain.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // 등산로 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('주요 등산로', style: AppTypography.titleLarge),
                      Text(
                        '${trails.length}개 코스',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // 등산로 리스트
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final trail = trails[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: _buildTrailCard(trail),
              );
            }, childCount: trails.length),
          ),

          // 하단 여백
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailCard(Trail trail) {
    return AppCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(trail.name, style: AppTypography.titleMedium),
              ),
              _buildDifficultyChip(trail.difficultyText),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            trail.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.route, size: 16, color: AppColors.textTertiary),
              SizedBox(width: AppSpacing.xs),
              Text('${trail.distance}km', style: AppTypography.caption),
              SizedBox(width: AppSpacing.lg),
              Icon(Icons.schedule, size: 16, color: AppColors.textTertiary),
              SizedBox(width: AppSpacing.xs),
              Text(
                '약 ${trail.estimatedTime ~/ 60}시간 ${trail.estimatedTime % 60}분',
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    final color = _getDifficultyColor(difficulty);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        difficulty,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '쉬움':
        return AppColors.success;
      case '보통':
        return AppColors.warning;
      case '어려움':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
