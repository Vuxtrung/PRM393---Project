import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

/// Màn hình chính — placeholder cho đến khi build UI Home đầy đủ.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      appBar: AppBar(
        title: Text(
          'Finzy',
          style: FinzyTheme.headlineSm.copyWith(color: FinzyTheme.onSurface),
        ),
        actions: [
          IconButton(
            onPressed: () => AppRoutes.replaceWith(context, AppRoutes.login),
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(FinzyTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: FinzyTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: FinzyTheme.onPrimary,
                  size: 40,
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),
              Text(
                'Chào mừng đến Finzy!',
                textAlign: TextAlign.center,
                style: FinzyTheme.headlineMd,
              ),
              const SizedBox(height: FinzyTheme.spacingSm),
              Text(
                'Bạn đã đăng nhập thành công.\nMàn hình Trang chủ sẽ được bổ sung sau.',
                textAlign: TextAlign.center,
                style: FinzyTheme.bodyMd.copyWith(
                  color: FinzyTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
