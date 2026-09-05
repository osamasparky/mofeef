import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class ExperienceCard extends StatelessWidget {
  final String title;
  final String category;
  final String location;
  final String price;
  final String? duration;
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.category,
    required this.location,
    required this.price,
    this.duration,
    required this.rating,
    required this.imageUrl,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Category & Favorite Badge
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: AppColors.surface,
                    child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Category Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                    ),
                    child: Text(
                      category,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.error : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Rating Badge
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.primaryGold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall,
                        ),
                      ),
                      if (duration != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time, color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(duration!, style: AppTypography.bodySmall),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: AppTypography.price,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldGlow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'احجز الآن',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
