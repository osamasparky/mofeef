import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds (Dark Luxury Theme)
  static const Color background = Color(0xFF020A12);
  static const Color backgroundSecondary = Color(0xFF061520);
  static const Color surface = Color(0xFF101C25);
  static const Color card = Color(0xFF1B2B36);
  static const Color cardAlt = Color(0xFF16232D);

  // Primary Heritage Gold Accents
  static const Color primaryGold = Color(0xFFFFBA00);
  static const Color primaryGoldLight = Color(0xFFF7BE2B);
  static const Color primaryGoldDark = Color(0xFFD49A00);
  static const Color goldGlow = Color(0x33FFBA00);

  // Secondary Accents (Teal / Emerald)
  static const Color accentTeal = Color(0xFF00BFB8);
  static const Color accentEmerald = Color(0xFF00BC7D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF91A2A7);
  static const Color textMuted = Color(0xFF63767B);
  static const Color textDark = Color(0xFF020A12);
  static const Color textGold = Color(0xFFFFBA00);

  // Borders & Dividers
  static const Color border = Color(0xFF273844);
  static const Color borderLight = Color(0x33FFFFFF);

  // Status Colors
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC05);
  static const Color error = Color(0xFFEA4335);
  static const Color info = Color(0xFF4285F4);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFBA00), Color(0xFFF7BE2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1B2B36), Color(0xFF101C25)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF061520), Color(0xFF020A12)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
