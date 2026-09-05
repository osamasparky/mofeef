import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/experience_card.dart';
import '../experiences/models/experience_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلات', style: AppTypography.headingSmall),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
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
              isFavorite: true,
              onTap: () => context.push('/experience/${exp.id}'),
            ),
          );
        },
      ),
    );
  }
}
