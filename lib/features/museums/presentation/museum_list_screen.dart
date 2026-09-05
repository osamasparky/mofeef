import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../data/museum_repository.dart';

class MuseumListScreen extends ConsumerStatefulWidget {
  const MuseumListScreen({super.key});

  @override
  ConsumerState<MuseumListScreen> createState() => _MuseumListScreenState();
}

class _MuseumListScreenState extends ConsumerState<MuseumListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final museumsAsync = ref.watch(museumsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('المتاحف والتراث', style: AppTypography.headingSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: 'ابحث عن متحف أو صرح تراثي...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: museumsAsync.when(
              data: (museums) {
                final filtered = _searchQuery.isEmpty
                    ? museums
                    : museums
                        .where((m) =>
                            m.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            (m.locationName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('لا توجد متاحف مطابقة للبحث', style: AppTypography.bodyMedium),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final museum = filtered[index];
                    return GestureDetector(
                      onTap: () => context.push('/museum/${museum.id}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: museum.imageUrl ?? 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800&q=80',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(
                                    height: 180,
                                    color: AppColors.surface,
                                    child: const Icon(Icons.museum_outlined, color: AppColors.primaryGold, size: 48),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${museum.rating}', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGold,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      museum.formattedPrice,
                                      style: AppTypography.titleSmall.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(museum.title, style: AppTypography.titleLarge),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 16),
                                      const SizedBox(width: 4),
                                      Text(museum.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
                                      const Spacer(),
                                      const Icon(Icons.access_time, color: AppColors.textSecondary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(museum.workingHours ?? '٩ص — ٩م', style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعذر تحميل قائمة المتاحف', style: AppTypography.bodyMedium),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.refresh(museumsListProvider),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
