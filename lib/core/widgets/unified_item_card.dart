import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class UnifiedItemCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? locationName;
  final double? rating;
  final String? subtitle;
  final String price;
  final Color accentColor;
  final VoidCallback onTap;
  final Widget? trailingBadge;

  const UnifiedItemCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.locationName,
    this.rating,
    this.subtitle,
    required this.price,
    this.accentColor = AppColors.primaryGold,
    required this.onTap,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF162534),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: accentColor.withOpacity(0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail Image on Leading side (in RTL this is the right side)
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                width: 105,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 105,
                  height: 100,
                  color: AppColors.surface,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 105,
                  height: 100,
                  color: AppColors.surface,
                  child: Icon(Icons.image_not_supported, color: accentColor.withOpacity(0.5), size: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row 1: Title and Chevron / Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (trailingBadge != null)
                        trailingBadge!
                      else
                        Icon(
                          isRtl ? Icons.chevron_left : Icons.chevron_right,
                          color: accentColor,
                          size: 22,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Row 2: Location
                  if (locationName != null && locationName!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: accentColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            locationName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF8B9CB0),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 14),

                  const SizedBox(height: 8),

                  // Row 3: Rating & Specs on one side, Price on the other side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating & Subtitle (e.g. ★ 4.8 • 7س)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (rating != null && rating! > 0) ...[
                            Icon(Icons.star, size: 14, color: accentColor),
                            const SizedBox(width: 3),
                            Text(
                              rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(0xFF8B9CB0),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          if (subtitle != null && subtitle!.isNotEmpty) ...[
                            if (rating != null && rating! > 0)
                              const Text(' • ', style: TextStyle(color: Color(0xFF8B9CB0), fontSize: 12)),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF8B9CB0),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Price in Bold Accent Color
                      Text(
                        price,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Tajawal',
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
