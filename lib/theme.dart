import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF0230FF);
  static const primaryDark = Color(0xFF001FCC);
  static const primaryLight = Color(0xFFE3EFFD);

  // Semantic
  static const success = Color(0xFF0D9F61);
  static const successLight = Color(0xFFE6F9F0);
  static const warning = Color(0xFFF5A623);
  static const warningLight = Color(0xFFFFF8E7);
  static const error = Color(0xFFDC3545);
  static const errorLight = Color(0xFFFDE8EA);

  // Light mode surfaces
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1B1B1F);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);

  // Dark mode surfaces — cool gray tinted to complement #0230FF
  static const darkBackground = Color(0xFF0E0E18);
  static const darkSurface = Color(0xFF1A1A28);
  static const darkCard = Color(0xFF21213A);
  static const darkTextPrimary = Color(0xFFEEEEFA);
  static const darkTextSecondary = Color(0xFF8888AA);
  static const darkBorder = Color(0xFF2C2C48);
  static const darkPrimaryLight = Color(0xFF161628);
  static const darkSuccessLight = Color(0xFF0A2A1C);
  static const darkWarningLight = Color(0xFF231A06);
  static const darkErrorLight = Color(0xFF280A0E);

  // Payment methods (same in both modes)
  static const gcash = Color(0xFF007DFE);
  static const maya = Color(0xFF2FB24B);
  static const card = Color(0xFF7C3AED);
}

class AppTheme {
  static ThemeData get theme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBackground : AppColors.background;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardColor = isDark ? AppColors.darkCard : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'HenrySans',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        surface: surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'HenrySans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.primary,
        indicatorColor: Colors.white.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 22);
          }
          return IconThemeData(
              color: Colors.white.withValues(alpha: 0.55), size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'HenrySans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            );
          }
          return TextStyle(
            fontFamily: 'HenrySans',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.55),
          );
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      textTheme: TextTheme(
        // ── Black (w900) ── hero numbers, large fee display
        displayLarge: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 56, color: textPrimary),
        displayMedium: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 40, color: textPrimary),
        displaySmall: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 32, color: textPrimary),

        // ── Bold (w700) ── screen titles, section headings
        headlineLarge: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 28, color: textPrimary),
        headlineMedium: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 22, color: textPrimary),
        headlineSmall: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),

        // ── Medium (w500) ── card titles, value labels
        titleLarge: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 16, color: textPrimary),
        titleMedium: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: textPrimary),
        titleSmall: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 13, color: textPrimary),

        // ── Regular (w400) ── body copy, descriptions
        bodyLarge: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: textSecondary),
        bodySmall: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 12, color: textSecondary),

        // ── Light (w300) ── fine print, disclaimers
        labelLarge: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary),
        labelMedium: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 12, color: textSecondary),
        labelSmall: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 11, color: textSecondary),
      ),
    );
  }
}

// Adaptive color helpers — use these in widgets instead of raw AppColors.*
extension AC on BuildContext {
  bool get _dark => Theme.of(this).brightness == Brightness.dark;

  Color get colBackground =>
      _dark ? AppColors.darkBackground : AppColors.background;
  Color get colSurface => _dark ? AppColors.darkSurface : AppColors.surface;
  Color get colCard => _dark ? AppColors.darkCard : AppColors.surface;
  Color get colBorder => _dark ? AppColors.darkBorder : AppColors.border;
  Color get colPrimaryLight =>
      _dark ? AppColors.darkPrimaryLight : AppColors.primaryLight;
  Color get colSuccessLight =>
      _dark ? AppColors.darkSuccessLight : AppColors.successLight;
  Color get colWarningLight =>
      _dark ? AppColors.darkWarningLight : AppColors.warningLight;
  Color get colErrorLight =>
      _dark ? AppColors.darkErrorLight : AppColors.errorLight;
  Color get colTextPrimary =>
      _dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get colTextSecondary =>
      _dark ? AppColors.darkTextSecondary : AppColors.textSecondary;
}
