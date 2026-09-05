import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/experience_card.dart';
import '../experiences/models/experience_model.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _selectedCategory = 'الكل';
  final List<String> _categories = ['الكل', 'المتاحف', 'المغامرات', 'التراث والآثار', 'الفعاليات', 'الأدلاء'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اكتشف روائع المملكة', style: AppTypography.headingSmall),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن وجهة، مدينة، أو معلم...',
                prefixIcon: Icon(Icons.search, color: AppColors.primaryGold),
                suffixIcon: Icon(Icons.tune, color: AppColors.textSecondary),
              ),
            ),
          ),

          // Filter Category Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                  selectedColor: AppColors.primaryGold,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryGold : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Grid / List of Experiences
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: mockExperiences.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final exp = mockExperiences[index];
                return SizedBox(
                  width: double.infinity,
                  child: ExperienceCard(
                    title: exp.title,
                    category: exp.category,
                    location: exp.location,
                    price: exp.price,
                    duration: exp.duration,
                    rating: exp.rating,
                    imageUrl: exp.imageUrl,
                    onTap: () => context.push('/experience/${exp.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
