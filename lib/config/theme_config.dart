import 'package:flutter/material.dart';

// Color Palette
class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF9B5D8F);
  static const Color primaryDark = Color(0xFF7A4A71);
  static const Color primaryLight = Color(0xFFC291B4);
  static const Color accentColor = Color(0xFFE8B4D9);

  // Background Colors
  static const Color bgPink = Color(0xFFF5E6F0);
  static const Color bgLightPink = Color(0xFFFAF0F6);

  // Text Colors
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color textGray = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Status Colors
  static const Color success = Color(0xFF28a745);
  static const Color error = Color(0xFFdc3545);
  static const Color warning = Color(0xFFffc107);
  static const Color info = Color(0xFF17a2b8);
}

// Typography
class AppTextStyles {
  // TODO: Uncomment when Poppins fonts are added
  // static const String fontFamily = 'Poppins';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Price Text
  static const TextStyle priceText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  // Category Badge
  static const TextStyle categoryBadge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
    letterSpacing: 0.5,
  );
}

// Spacing & Layout
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Card Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusPill = 50.0;
}

// Material Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // fontFamily: AppTextStyles.fontFamily,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.bgLightPink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.white,
        background: AppColors.bgLightPink,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          // fontFamily: AppTextStyles.fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        color: AppColors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: const TextTheme(
        titleLarge: AppTextStyles.h4,
        titleMedium: AppTextStyles.h3,
        titleSmall: AppTextStyles.h4,

        // Body text
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,

        // Buttons
        labelLarge: AppTextStyles.buttonLarge,
        labelMedium: AppTextStyles.buttonMedium,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // fontFamily: AppTextStyles.fontFamily,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.accentColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        error: const Color(0xFFCF6679),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          // fontFamily: AppTextStyles.fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          textStyle: AppTextStyles.buttonLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white60),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
    );
  }
}
