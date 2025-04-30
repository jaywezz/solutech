import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _themeData(Brightness.light);
  static ThemeData get dark => _themeData(Brightness.dark);

  static ThemeData _themeData(Brightness brightness) {
    final lightTheme = FlexThemeData.light(
      colors: FlexSchemeColor(
        primary: const Color(0xFF0072CE), // Logo blue
        primaryContainer: const Color(0xFFE3F2FD), // Light blue for containers
        secondary: const Color(0xFFFFB81C), // Logo gold
        secondaryContainer: const Color(0xFFFFECB3), // Light gold for containers
        tertiary: const Color(0xFF1E88E5), // Accent blue
        tertiaryContainer: const Color(0xFFBBDEFB), // Light accent blue for containers
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      subThemesData: const FlexSubThemesData(
        useM2StyleDividerInM3: true,
        blendOnLevel: 6,
        blendOnColors: false,
        useTextTheme: true,
        adaptiveRadius: FlexAdaptive.excludeWebAndroidFuchsia(),
        defaultRadiusAdaptive: 10.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        elevatedButtonRadius: 12,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        toggleButtonsBorderSchemeColor: SchemeColor.primary,
        segmentedButtonSchemeColor: SchemeColor.primary,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorIsFilled: false,
        inputDecoratorBorderSchemeColor: SchemeColor.primary,
        inputDecoratorBorderWidth: 0.5,
        inputDecoratorRadius: 12,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.onSurface,
        inputSelectionHandleSchemeColor: SchemeColor.primaryContainer,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarIndicatorOpacity: 1.00,
        navigationBarElevation: 0.0,
        navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        cardRadius: 16.0,
        popupMenuRadius: 8.0,
        dialogRadius: 16.0,
        bottomSheetRadius: 16.0,
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );

    return lightTheme;
  }
}

