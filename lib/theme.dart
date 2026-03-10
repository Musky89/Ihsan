import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SacredMood { indigo, parchment, gold, rose, obsidian, teal, ramadan }

class SacredColors {
  static const Color indigo = Color(0xFF1B1464);
  static const Color moonlight = Color(0xFFF0EDE5);
  static const Color moonlightSoft = Color(0xFFD9D5CC);
  static const Color gold = Color(0xFFD4A843);
  static const Color rose = Color(0xFFC4737B);
  static const Color teal = Color(0xFF0A6E6E);
  static const Color deepEarth = Color(0xFF3D2B1F);
  static const Color obsidian = Color(0xFF0A0A14);
  static const Color obsidianSoft = Color(0xFF141425);
  static const Color panel = Color(0xFF1A1B34);
  static const Color panelRaised = Color(0xFF222448);
  static const Color muted = Color(0xFF6B6B8D);
  static const Color success = Color(0xFF7EBB7C);
  static const Color shadow = Color(0xFF05050B);
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
      GoogleFonts.manropeTextTheme(
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
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
        height: 0.92,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
        height: 0.94,
      ),
      headlineLarge: GoogleFonts.fraunces(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: SacredColors.moonlight,
      ),
      titleLarge: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: SacredColors.moonlight,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: SacredColors.moonlight,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: SacredColors.moonlight,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: SacredColors.moonlightSoft,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: SacredColors.muted,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w800,
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
      fillColor: SacredColors.panel.withValues(alpha: 0.88),
      hintStyle: GoogleFonts.manrope(
        color: SacredColors.muted,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: SacredColors.gold, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: SacredColors.panel.withValues(alpha: 0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: SacredColors.panelRaised.withValues(alpha: 0.9),
      selectedColor: SacredColors.gold,
      labelStyle: GoogleFonts.manrope(
        color: SacredColors.moonlight,
        fontWeight: FontWeight.w700,
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
        colors: [Color(0xFF090911), Color(0xFF111228), Color(0xFF1A164A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    case SacredMood.indigo:
      return const LinearGradient(
        colors: [Color(0xFF20146A), Color(0xFF121A48), Color(0xFF090911)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
  }
}

LinearGradient sacredPanelGradient({
  required SacredMood mood,
  bool invert = false,
}) {
  if (invert) {
    return const LinearGradient(
      colors: <Color>[Color(0xFFF5F1E8), Color(0xFFE6DCC9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  switch (mood) {
    case SacredMood.gold:
      return LinearGradient(
        colors: <Color>[
          SacredColors.panelRaised,
          SacredColors.panel,
          SacredColors.deepEarth.withValues(alpha: 0.95),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.parchment:
      return const LinearGradient(
        colors: <Color>[Color(0xFFF3EEE3), Color(0xFFE6D8C2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.ramadan:
      return LinearGradient(
        colors: <Color>[
          const Color(0xFF6A4375),
          SacredColors.panel,
          SacredColors.gold.withValues(alpha: 0.28),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.rose:
      return LinearGradient(
        colors: <Color>[
          const Color(0xFF372347),
          SacredColors.panelRaised,
          SacredColors.rose.withValues(alpha: 0.20),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.teal:
      return LinearGradient(
        colors: <Color>[
          const Color(0xFF112B32),
          SacredColors.panel,
          SacredColors.teal.withValues(alpha: 0.22),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case SacredMood.obsidian:
    case SacredMood.indigo:
      return LinearGradient(
        colors: <Color>[
          SacredColors.panelRaised,
          SacredColors.panel,
          SacredColors.indigo.withValues(alpha: 0.18),
        ],
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
