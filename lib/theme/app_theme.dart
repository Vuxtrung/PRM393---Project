import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens and theme configuration for the Finzy app.
///
/// Derived from the Vietnamese Personal Finance Design System:
/// Deep Teal primary, Amber secondary accent, Inter + Be Vietnam Pro typography.
class FinzyTheme {
  FinzyTheme._();

  // ---------------------------------------------------------------------------
  // Brand & semantic colors
  // ---------------------------------------------------------------------------

  /// Deep Teal — primary brand color (stability, growth).
  static const Color primary = Color(0xFF005454);

  /// Text/icons on primary surfaces.
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Filled primary button hover/pressed tone.
  static const Color primaryContainer = Color(0xFF0D6E6E);

  /// Text on primary container surfaces.
  static const Color onPrimaryContainer = Color(0xFF9DEDEC);

  /// Inverse primary for dark surfaces.
  static const Color inversePrimary = Color(0xFF84D4D3);

  /// Amber — secondary accent for CTAs and savings nudges.
  static const Color secondary = Color(0xFF835500);

  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFEAE2C);
  static const Color onSecondaryContainer = Color(0xFF6B4500);

  /// Warm brown tertiary for supporting UI.
  static const Color tertiary = Color(0xFF743C1D);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF915332);
  static const Color onTertiaryContainer = Color(0xFFFFD8C6);

  // ---------------------------------------------------------------------------
  // Surface & background
  // ---------------------------------------------------------------------------

  static const Color background = Color(0xFFF7FAF9);
  static const Color onBackground = Color(0xFF181C1C);

  static const Color surface = Color(0xFFF7FAF9);
  static const Color surfaceDim = Color(0xFFD7DBDA);
  static const Color surfaceBright = Color(0xFFF7FAF9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F4F3);
  static const Color surfaceContainer = Color(0xFFEBEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E8);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E2);
  static const Color surfaceVariant = Color(0xFFE0E3E2);

  static const Color onSurface = Color(0xFF181C1C);
  static const Color onSurfaceVariant = Color(0xFF3E4948);

  static const Color inverseSurface = Color(0xFF2D3131);
  static const Color inverseOnSurface = Color(0xFFEEF1F0);

  static const Color outline = Color(0xFF6E7979);
  static const Color outlineVariant = Color(0xFFBEC9C8);
  static const Color surfaceTint = Color(0xFF016A6A);

  // ---------------------------------------------------------------------------
  // Fixed tonal roles (chips, secondary buttons, highlights)
  // ---------------------------------------------------------------------------

  static const Color primaryFixed = Color(0xFFA0F0F0);
  static const Color primaryFixedDim = Color(0xFF84D4D3);
  static const Color onPrimaryFixed = Color(0xFF002020);
  static const Color onPrimaryFixedVariant = Color(0xFF004F50);

  static const Color secondaryFixed = Color(0xFFFFDDB4);
  static const Color secondaryFixedDim = Color(0xFFFFB955);
  static const Color onSecondaryFixed = Color(0xFF291800);
  static const Color onSecondaryFixedVariant = Color(0xFF633F00);

  // ---------------------------------------------------------------------------
  // Error & financial semantics
  // ---------------------------------------------------------------------------

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  /// Positive balances / income (Success Green).
  static const Color income = Color(0xFF15803D);

  /// Negative balances / expenses (Danger Red).
  static const Color expense = error;

  // ---------------------------------------------------------------------------
  // Layout tokens
  // ---------------------------------------------------------------------------

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  static const double marginMobile = 16;
  static const double marginDesktop = 24;
  static const double gutter = 16;

  /// 4px — chips, small elements.
  static const double radiusSm = 4;

  /// 8px — default rounding.
  static const double radiusDefault = 8;

  /// 12px — buttons and input fields.
  static const double radiusMd = 12;

  /// 16px — standard content cards.
  static const double radiusLg = 16;

  /// 24px — large containers.
  static const double radiusXl = 24;

  /// Pill shape for category chips.
  static const double radiusFull = 9999;

  /// Minimum touch target for buttons (design spec).
  static const double buttonMinHeight = 48;

  /// Bottom nav minimum height including safe area.
  static const double bottomNavMinHeight = 84;

  static const double iconSize = 24;

  // ---------------------------------------------------------------------------
  // Elevation shadows (tonal layers + ambient shadows)
  // ---------------------------------------------------------------------------

  /// Level 1 — cards on the main canvas.
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  /// Level 2 — modals and overlays.
  static List<BoxShadow> get modalShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  /// Bottom navigation top border color.
  static const Color bottomNavBorder = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static TextStyle get displayCurrency => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
        color: onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.beVietnamPro(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: onSurface,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.beVietnamPro(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        color: onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.beVietnamPro(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.beVietnamPro(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: onSurface,
      );

  /// Uppercase labels with increased letter spacing.
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: onSurfaceVariant,
      );

  /// Maps design tokens onto Flutter's [TextTheme].
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayCurrency,
        headlineLarge: headlineLg,
        headlineMedium: headlineMd,
        headlineSmall: headlineSm,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        labelMedium: labelMd,
        titleLarge: headlineLg,
        titleMedium: headlineMd,
        titleSmall: headlineSm,
        bodySmall: labelMd,
        labelLarge: bodyMd.copyWith(fontWeight: FontWeight.w500),
        labelSmall: labelMd,
      );

  // ---------------------------------------------------------------------------
  // Material [ThemeData]
  // ---------------------------------------------------------------------------

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surfaceContainerLowest,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      surfaceTint: surfaceTint,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: headlineLgMobile,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(buttonMinHeight),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: bodyLg.copyWith(
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          backgroundColor: primaryFixed,
          minimumSize: const Size.fromHeight(buttonMinHeight),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: bodyLg.copyWith(
            fontWeight: FontWeight.w600,
            color: primary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm + 4,
        ),
        hintStyle: bodyMd.copyWith(color: outline),
        labelStyle: labelMd,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerLow,
        labelStyle: labelMd.copyWith(letterSpacing: 0),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm + 4,
          vertical: spacingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLowest.withValues(alpha: 0.92),
        selectedItemColor: primary,
        unselectedItemColor: outline,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: labelMd.copyWith(color: primary, letterSpacing: 0),
        unselectedLabelStyle: labelMd.copyWith(letterSpacing: 0),
      ),
    );
  }

  /// Formats a VND amount using the design convention: `1.250.000 ₫`.
  static TextStyle currencyStyle({
    required double amount,
    TextStyle? base,
  }) {
    final style = base ?? displayCurrency;
    return style.copyWith(
      color: amount >= 0 ? income : expense,
      fontWeight: FontWeight.w700,
    );
  }
}

// =============================================================================
// Reusable widgets
// =============================================================================

/// Primary CTA — Deep Teal background, white label, 48px min height.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expand = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: FinzyTheme.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: FinzyTheme.iconSize),
                const SizedBox(width: FinzyTheme.spacingSm),
              ],
              Text(label),
            ],
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: child,
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Secondary action — light teal tint fill with teal text.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: FinzyTheme.iconSize),
          const SizedBox(width: FinzyTheme.spacingSm),
        ],
        Text(label),
      ],
    );

    final button = OutlinedButton(
      onPressed: onPressed,
      child: child,
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Outlined text field matching the design system (1px border, 2px primary on focus).
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      autofocus: autofocus,
      style: FinzyTheme.bodyLg,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Standard content card — white surface, 16px radius, soft ambient shadow.
class FinzyCard extends StatelessWidget {
  const FinzyCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(FinzyTheme.spacingMd),
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
        boxShadow: elevated ? FinzyTheme.modalShadow : FinzyTheme.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
        child: content,
      ),
    );
  }
}

/// Uppercase section label with design-system letter spacing.
class FinzySectionLabel extends StatelessWidget {
  const FinzySectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: FinzyTheme.labelMd,
    );
  }
}
