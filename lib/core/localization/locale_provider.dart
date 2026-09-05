import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';
import 'app_strings.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final FlutterSecureStorage _storage;

  LocaleNotifier(this._storage) : super(const Locale('ar')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final savedCode = await _storage.read(key: 'app_locale');
      if (savedCode != null && (savedCode == 'ar' || savedCode == 'en')) {
        state = Locale(savedCode);
      }
    } catch (_) {}
  }

  Future<void> setLocale(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') return;
    state = Locale(languageCode);
    try {
      await _storage.write(key: 'app_locale', value: languageCode);
    } catch (_) {}
  }

  Future<void> toggleLocale() async {
    final next = state.languageCode == 'ar' ? 'en' : 'ar';
    await setLocale(next);
  }

  bool get isArabic => state.languageCode == 'ar';
}

extension AppLocalizationRef on WidgetRef {
  String tr(String key) {
    final locale = watch(localeProvider);
    return AppStrings.get(key, locale.languageCode);
  }
}
