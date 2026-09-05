import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText = 'عرض الكل',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.headingSmall),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppTypography.bodySmall),
              ],
            ],
          ),
          if (onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primaryGold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
