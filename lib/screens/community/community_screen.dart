// screens/community/community_screen.dart

import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../data/models/index.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // 임시 데이터
  final List<PhotoSpot> photoSpots = [
    PhotoSpot(
      id: '1',
      userId: 'user1',
      userName: '산악인김',
      mountainId: '1',
      mountainName: '북한산',
      imageUrl: 'https://example.com/photo1.jpg',
      spotName: '백운대 정상',
      description: '북한산 최고봉에서 바라본 서울 전경! 날씨가 맑아서 남산타워까지 보였어요 😊',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      likeCount: 42,
      commentCount: 5,
    ),
    PhotoSpot(
      id: '2',
      userId: 'user2',
      userName: '등산매니아',
      mountainId: '2',
      mountainName: '설악산',
      imageUrl: 'https://example.com/photo2.jpg',
      spotName: '천불동계곡',
      description: '설악산의 숨은 비경! 가을 단풍이 정말 환상적이었습니다.',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      likeCount: 128,
      commentCount: 12,
    ),
    PhotoSpot(
      id: '3',
      userId: 'user3',
      userName: '제주하이커',
      mountainId: '3',
      mountainName: '한라산',
      imageUrl: 'https://example.com/photo3.jpg',
      spotName: '백록담',
      description: '한라산 정상 백록담의 장엄한 모습. 구름 위를 걷는 기분이었어요!',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      likeCount: 256,
      commentCount: 23,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _showAddPhotoSpot,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: AppColors.primary,
        child: ListView.separated(
          padding: EdgeInsets.all(AppSpacing.lg),
          itemCount: photoSpots.length,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.lg),
          itemBuilder: (context, index) {
            final spot = photoSpots[index];
            return PhotoSpotCard(
              imageUrl: spot.imageUrl,
              mountainName: spot.mountainName,
              spotName: spot.spotName,
              authorName: spot.userName,
              likes: spot.likeCount,
              onTap: () => _showPhotoDetail(spot),
              onLike: () => _toggleLike(spot),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshFeed() async {
    // 피드 새로고침 로직
    await Future.delayed(Duration(seconds: 1));
  }

  void _showAddPhotoSpot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => const AddPhotoSpotBottomSheet(),
    );
  }

  void _showPhotoDetail(PhotoSpot spot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(photoSpot: spot),
      ),
    );
  }

  void _toggleLike(PhotoSpot spot) {
    setState(() {
      // 좋아요 토글 로직
    });
  }
}

// 포토스팟 추가 바텀시트
class AddPhotoSpotBottomSheet extends StatelessWidget {
  const AddPhotoSpotBottomSheet({super.key});

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
            Text('포토스팟 공유', style: AppTypography.headlineMedium),
            SizedBox(height: AppSpacing.xl),

            // 사진 선택
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      '사진 선택',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // 산 선택
            MountainSearchBar(hintText: '산 이름을 검색하세요'),

            SizedBox(height: AppSpacing.lg),

            // 포토스팟 이름
            TextField(
              decoration: InputDecoration(
                labelText: '포토스팟 이름',
                hintText: '예: 백운대 정상',
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // 설명
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '설명',
                hintText: '이 장소의 특별한 점을 공유해주세요',
                alignLabelWithHint: true,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // 공유 버튼
            AppButton(
              text: '공유하기',
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

// 포토 상세 화면
class PhotoDetailScreen extends StatefulWidget {
  final PhotoSpot photoSpot;

  const PhotoDetailScreen({super.key, required this.photoSpot});

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  // 임시 댓글 데이터
  final List<Comment> comments = [
    Comment(
      id: '1',
      photoSpotId: '1',
      userId: 'user4',
      userName: '산을좋아해',
      content: '와 정말 멋진 풍경이네요! 저도 다음주에 가볼 예정입니다.',
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Comment(
      id: '2',
      photoSpotId: '1',
      userId: 'user5',
      userName: '등산초보',
      content: '날씨가 정말 좋았네요! 몇시쯤 찍으신 사진인가요?',
      createdAt: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.photoSpot.spotName),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: AppColors.surfaceVariant,
                      child: Center(
                        child: Icon(
                          Icons.landscape,
                          size: 80,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),

                  // 정보
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                widget.photoSpot.userName[0],
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.photoSpot.userName,
                                    style: AppTypography.labelLarge,
                                  ),
                                  Text(
                                    _getTimeAgo(widget.photoSpot.createdAt),
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildActionButton(
                              Icons.favorite_border,
                              widget.photoSpot.likeCount.toString(),
                              AppColors.error,
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // 산 정보
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                          child: Text(
                            widget.photoSpot.mountainName,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: AppSpacing.md),

                        // 설명
                        Text(
                          widget.photoSpot.description,
                          style: AppTypography.bodyMedium.copyWith(height: 1.6),
                        ),

                        SizedBox(height: AppSpacing.xl),
                        Divider(),
                        SizedBox(height: AppSpacing.lg),

                        // 댓글
                        Text(
                          '댓글 ${comments.length}',
                          style: AppTypography.titleMedium,
                        ),
                        SizedBox(height: AppSpacing.lg),

                        ...comments.map((comment) => _buildComment(comment)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 댓글 입력
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  IconButton(
                    onPressed: _addComment,
                    icon: Icon(Icons.send),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceVariant,
            child: Text(
              comment.userName[0],
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.userName, style: AppTypography.labelMedium),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      _getTimeAgo(comment.createdAt),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Text(comment.content, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${(diff.inDays / 7).floor()}주 전';
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      // 댓글 추가 로직
      _commentController.clear();
    }
  }
}
