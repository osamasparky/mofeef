class AppCurrency {
  AppCurrency._();

  static const String symbol = '﷼';

  static String format(num? amount, {bool isArabic = true}) {
    if (amount == null) return isArabic ? '0 ﷼' : '0 SAR';
    final formatted = (amount == amount.roundToDouble())
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return isArabic ? '$formatted ﷼' : '$formatted SAR';
  }
}
