import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'color_extensions.dart';

final ThemeData lightTheme = _buildTheme(Brightness.light);
final ThemeData darkTheme = _buildTheme(Brightness.dark);
final ThemeData appTheme = darkTheme;

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = _buildColorScheme(brightness);
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    dividerColor: colorScheme.outlineVariant,
    disabledColor: colorScheme.onSurface.withValues(alpha: 0.38),
    extensions: const [
      ExtraColors(success: AppColors.success, warning: AppColors.warning),
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      elevation: isDark ? 0 : 1,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return TextStyle(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        );
      }),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.primary.withValues(alpha: 0.12),
      circularTrackColor: colorScheme.primary.withValues(alpha: 0.12),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: BorderSide(color: colorScheme.outline),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
      ),
      prefixIconColor: colorScheme.onSurfaceVariant,
      suffixIconColor: colorScheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.45),
        disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.7),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        side: WidgetStatePropertyAll(
          BorderSide(color: colorScheme.outlineVariant),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      selectedColor: colorScheme.primary,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
  );
}

ColorScheme _buildColorScheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  if (isDark) {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Color(0xFF042F3A),
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.textPrimaryDark,
      outline: Color(0xFF4B4868),
      outlineVariant: Color(0xFF353252),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFF5F5FF),
      onInverseSurface: AppColors.textPrimary,
      inversePrimary: Color(0xFFA5B4FC),
      primaryContainer: Color(0xFF312E81),
      onPrimaryContainer: Color(0xFFE0E7FF),
      secondaryContainer: Color(0xFF0E7490),
      onSecondaryContainer: Color(0xFFCFFAFE),
      tertiary: AppColors.success,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF14532D),
      onTertiaryContainer: Color(0xFFDCFCE7),
      surfaceDim: AppColors.darkBackground,
      surfaceBright: AppColors.darkCard,
      surfaceContainerLowest: AppColors.darkBackground,
      surfaceContainerLow: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurface,
      surfaceContainerHigh: AppColors.darkCard,
      surfaceContainerHighest: Color(0xFF2D2A4E),
    );
  }

  return const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Color(0xFF083344),
    error: AppColors.error,
    onError: Colors.white,
    surface: AppColors.lightBackground,
    onSurface: AppColors.textPrimary,
    outline: Color(0xFFC7D2FE),
    outlineVariant: Color(0xFFE4E7F5),
    shadow: Color(0x1A0F172A),
    scrim: Colors.black,
    inverseSurface: Color(0xFF1A1830),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFFA5B4FC),
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: Color(0xFF312E81),
    secondaryContainer: Color(0xFFCFFAFE),
    onSecondaryContainer: Color(0xFF164E63),
    tertiary: AppColors.success,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFDCFCE7),
    onTertiaryContainer: Color(0xFF166534),
    surfaceDim: Color(0xFFE6E8F5),
    surfaceBright: Colors.white,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFAFAFF),
    surfaceContainer: AppColors.lightBackground,
    surfaceContainerHigh: Color(0xFFEEF2FF),
    surfaceContainerHighest: Color(0xFFE5E7FF),
  );
}
