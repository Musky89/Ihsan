import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SacredMood { indigo, parchment, gold, rose, obsidian, teal, ramadan }

class SacredColors {
  static const Color indigo = Color(0xFF1B1464);
  static const Color moonlight = Color(0xFFF0EDE5);
  static const Color gold = Color(0xFFD4A843);
  static const Color rose = Color(0xFFC4737B);
  static const Color teal = Color(0xFF0A6E6E);
  static const Color deepEarth = Color(0xFF3D2B1F);
  static const Color obsidian = Color(0xFF0A0A14);
  static const Color muted = Color(0xFF6B6B8D);
  static const Color success = Color(0xFF7EBB7C);
}

ThemeData buildSacredTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: SacredColors.indigo,
        brightness: Brightness.dark,
      ).copyWith(
        primary: SacredColors.gold,
        secondary: SacredColors.rose,
        surface: SacredColors.obsidian,
        onSurface: SacredColors.moonlight,
        onPrimary: SacredColors.obsidian,
        onSecondary: SacredColors.obsidian,
      );

  final baseText =
      GoogleFonts.plusJakartaSansTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ).apply(
        bodyColor: SacredColors.moonlight,
        displayColor: SacredColors.moonlight,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: SacredColors.obsidian,
    textTheme: baseText.copyWith(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
        height: 0.96,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
        height: 1.0,
      ),
      headlineLarge: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
      ),
      titleLarge: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: SacredColors.moonlight,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: SacredColors.moonlight,
        height: 1.4,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: SacredColors.moonlight,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: SacredColors.muted,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: SacredColors.obsidian,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: SacredColors.moonlight),
      titleTextStyle: GoogleFonts.fraunces(
        color: SacredColors.moonlight,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      hintStyle: GoogleFonts.plusJakartaSans(
        color: SacredColors.muted,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: SacredColors.gold, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.06),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withValues(alpha: 0.07),
      selectedColor: SacredColors.gold,
      labelStyle: GoogleFonts.plusJakartaSans(
        color: SacredColors.moonlight,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
    ),
    dividerColor: Colors.white.withValues(alpha: 0.08),
  );
}

LinearGradient sacredGradient(SacredMood mood) {
  switch (mood) {
    case SacredMood.parchment:
      return const LinearGradient(
        colors: [Color(0xFFF0EDE5), Color(0xFFE2D9C7), Color(0xFFB18A52)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.gold:
      return const LinearGradient(
        colors: [Color(0xFFD4A843), Color(0xFFA86D21), Color(0xFF3D2B1F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.rose:
      return const LinearGradient(
        colors: [Color(0xFFC4737B), Color(0xFF7A3F5C), Color(0xFF1B1464)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.teal:
      return const LinearGradient(
        colors: [Color(0xFF0A6E6E), Color(0xFF0C3746), Color(0xFF0A0A14)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.ramadan:
      return const LinearGradient(
        colors: [Color(0xFF3A1C58), Color(0xFF6A3D70), Color(0xFFD4A843)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case SacredMood.obsidian:
      return const LinearGradient(
        colors: [Color(0xFF0A0A14), Color(0xFF14152A), Color(0xFF1B1464)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.indigo:
      return const LinearGradient(
        colors: [Color(0xFF1B1464), Color(0xFF11173C), Color(0xFF0A0A14)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
  }
}

Color sacredAccent(SacredMood mood) {
  switch (mood) {
    case SacredMood.parchment:
      return SacredColors.deepEarth;
    case SacredMood.gold:
      return SacredColors.moonlight;
    case SacredMood.rose:
      return SacredColors.rose;
    case SacredMood.teal:
      return SacredColors.teal;
    case SacredMood.ramadan:
      return SacredColors.gold;
    case SacredMood.obsidian:
      return SacredColors.gold;
    case SacredMood.indigo:
      return SacredColors.gold;
  }
}

Color readableForeground(SacredMood mood) {
  if (mood == SacredMood.parchment) {
    return SacredColors.obsidian;
  }
  return SacredColors.moonlight;
}
