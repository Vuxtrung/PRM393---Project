import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

/// Màn hình quên mật khẩu — placeholder gửi email khôi phục.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'example@email.com');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Vui lòng nhập email.');
      return;
    }

    _showMessage('Link khôi phục đã được gửi đến $email (mock).');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) AppRoutes.pop(context);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.pop(context),
        ),
        title: Text(
          'Quên mật khẩu',
          style: FinzyTheme.headlineSm.copyWith(color: FinzyTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(FinzyTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Khôi phục mật khẩu',
                style: FinzyTheme.headlineLgMobile,
              ),
              const SizedBox(height: FinzyTheme.spacingSm),
              Text(
                'Nhập email đã đăng ký. Chúng tôi sẽ gửi link đặt lại mật khẩu.',
                style: FinzyTheme.bodyMd.copyWith(
                  color: FinzyTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingXl),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: FinzyTheme.outline,
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),
              PrimaryButton(
                label: 'Gửi link khôi phục',
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
