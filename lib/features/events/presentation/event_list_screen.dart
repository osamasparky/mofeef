import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/event_repository.dart';

class EventItemModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final String price;
  final String imageUrl;

  const EventItemModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.imageUrl,
  });
}

class EventListScreen extends ConsumerWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('الفعاليات والمواسم السعودية', style: AppTypography.headingSmall),
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Text('لا توجد فعاليات متاحة حالياً', style: AppTypography.bodyMedium),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final ev = events[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: ev.imageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 160,
                        color: AppColors.surface,
                        child: const Icon(Icons.festival_outlined, size: 48, color: AppColors.textMuted),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('فعالية رسمية', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
                              ),
                              Text(ev.date, style: AppTypography.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(ev.title, style: AppTypography.titleLarge),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(ev.location, style: AppTypography.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ev.price, style: AppTypography.price),
                              CustomButton(
                                text: 'حجز التذاكر',
                                width: 130,
                                height: 42,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('تم فتح نافذة حجز تذاكر الفعالية!'), backgroundColor: AppColors.success),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تعذر تحميل بيانات الفعاليات', style: AppTypography.bodyMedium),
              TextButton(
                onPressed: () => ref.refresh(eventsListProvider),
                child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.primaryGold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
