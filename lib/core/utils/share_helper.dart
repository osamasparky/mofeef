import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  static Future<void> shareItem({
    required BuildContext context,
    required String title,
    required String category,
    required String id,
    String? price,
    String? location,
    String? type, // 'tour', 'museum', 'event', 'guide', 'car', 'shop', 'location'
  }) async {
    final typePath = switch (type) {
      'tour' => 'tour',
      'museum' => 'museum',
      'event' => 'event',
      'guide' => 'guide',
      'car' => 'car',
      'shop' || 'product' => 'shop',
      'location' => 'location',
      _ => 'experience',
    };

    final webUrl = 'https://staging.modeefe.com/ar/$typePath/$id';
    final appDeepLink = 'modeef://$typePath/$id';

    final buffer = StringBuffer();
    buffer.writeln('✨ اكتشف $title على منصة مُضيف للسياحة والضيافة الفاخرة');
    if (category.isNotEmpty) buffer.writeln('🏷️ التصنيف: $category');
    if (location != null && location.isNotEmpty) buffer.writeln('📍 الموقع: $location');
    if (price != null && price.isNotEmpty) buffer.writeln('💰 السعر: $price');
    buffer.writeln();
    buffer.writeln('🔗 رابط التجربة:');
    buffer.writeln(webUrl);
    buffer.writeln();
    buffer.writeln('📲 حمّل تطبيق مُضيف أو افتح الرابط للاستمتاع برحلتك السعودية:');
    buffer.writeln(appDeepLink);

    try {
      final box = context.findRenderObject() as RenderBox?;
      final rect = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
      // ignore: deprecated_member_use
      await Share.share(
        buffer.toString(),
        subject: title,
        sharePositionOrigin: rect,
      );
    } catch (_) {}
  }
}
