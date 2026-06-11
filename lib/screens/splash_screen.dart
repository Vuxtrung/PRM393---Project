import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

/// Màn hình Splash — giới thiệu thương hiệu Finzy khi mở app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _appName = 'Finzy';
  static const String _tagline = 'Quản lý chi tiêu, làm chủ tương lai';
  static const Duration _splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future<void>.delayed(_splashDuration);
    if (!mounted) return;
    await AppRoutes.replaceWith(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final safePadding = MediaQuery.paddingOf(context);
    final contentHeight = viewportHeight - safePadding.top - safePadding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: FinzyTheme.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: contentHeight,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FinzyTheme.marginMobile,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _FinzyLogo(),
                            const SizedBox(height: FinzyTheme.spacingLg),
                            Text(
                              _appName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                color: FinzyTheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: FinzyTheme.spacingSm),
                            Text(
                              _tagline,
                              textAlign: TextAlign.center,
                              style: FinzyTheme.bodyMd.copyWith(
                                color: FinzyTheme.onPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: FinzyTheme.spacingXl + 16),
                    child: _LoadingDots(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo Finzy: squircle trắng nằm trong viền tròn mảnh.
class _FinzyLogo extends StatelessWidget {
  const _FinzyLogo();

  static const double _outerSize = 140;
  static const double _innerSize = 72;
  static const double _borderWidth = 1.5;
  static const double _innerRadius = 18;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _outerSize,
      height: _outerSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: FinzyTheme.onPrimary.withValues(alpha: 0.85),
            width: _borderWidth,
          ),
        ),
        child: Center(
          child: Container(
            width: _innerSize,
            height: _innerSize,
            decoration: BoxDecoration(
              color: FinzyTheme.onPrimary,
              borderRadius: BorderRadius.circular(_innerRadius),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ba chấm trắng — chỉ báo đang tải ở cuối màn hình.
class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  static const double _dotSize = 8;
  static const double _dotSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isMiddle = index == 1;
        return Padding(
          padding: EdgeInsets.only(
            right: index < 2 ? _dotSpacing : 0,
          ),
          child: Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FinzyTheme.onPrimary.withValues(
                alpha: isMiddle ? 1.0 : 0.55,
              ),
            ),
          ),
        );
      }),
    );
  }
}
