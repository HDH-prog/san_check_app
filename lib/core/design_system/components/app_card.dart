import 'package:flutter/material.dart';
import '../foundation/app_colors.dart';
import '../foundation/app_spacing.dart';
import '../foundation/app_typography.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final double? elevation;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? AppSpacing.elevation2,
      color: backgroundColor ?? AppColors.white,
      margin: margin ?? EdgeInsets.all(AppSpacing.cardSpacing),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: border != null ? border!.top : BorderSide.none,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.cardPadding),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: card,
      );
    }

    return card;
  }
}

// 산 정보 카드
class MountainInfoCard extends StatelessWidget {
  final String name;
  final String height;
  final String location;
  final String? difficulty;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MountainInfoCard({
    super.key,
    required this.name,
    required this.height,
    required this.location,
    this.difficulty,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // 산 이미지 또는 아이콘
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: AppColors.surfaceVariant,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildMountainIcon();
                      },
                    ),
                  )
                : _buildMountainIcon(),
          ),
          SizedBox(width: AppSpacing.lg),

          // 산 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleMedium),
                SizedBox(height: AppSpacing.xs),
                Text(
                  height,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  location,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // 난이도 (있는 경우)
          if (difficulty != null) ...[
            SizedBox(width: AppSpacing.sm),
            _buildDifficultyChip(difficulty!),
          ],
        ],
      ),
    );
  }

  Widget _buildMountainIcon() {
    return Icon(
      Icons.landscape,
      size: 32,
      color: AppColors.primary.withOpacity(0.6),
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
    switch (difficulty.toLowerCase()) {
      case '쉬움':
      case 'easy':
        return AppColors.success;
      case '보통':
      case 'medium':
        return AppColors.warning;
      case '어려움':
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

// 커뮤니티 포토 카드
class PhotoSpotCard extends StatelessWidget {
  final String imageUrl;
  final String mountainName;
  final String spotName;
  final String authorName;
  final int likes;
  final VoidCallback? onTap;
  final VoidCallback? onLike;

  const PhotoSpotCard({
    super.key,
    required this.imageUrl,
    required this.mountainName,
    required this.spotName,
    required this.authorName,
    required this.likes,
    this.onTap,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceVariant,
                    child: Icon(
                      Icons.landscape,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
          ),

          // 내용
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spotName, style: AppTypography.titleMedium),
                SizedBox(height: AppSpacing.xs),
                Text(
                  mountainName,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by $authorName',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: onLike,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.xs),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  likes.toString(),
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
