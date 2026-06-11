import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

/// Màn hình đăng nhập — UI tĩnh theo design Finzy.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Mock data tĩnh — chưa kết nối Firebase hay xác thực thật.
  static const String _title = 'Chào mừng trở lại!';
  static const String _subtitle =
      'Quản lý tài chính cá nhân dễ dàng cùng Finzy.';
  static const String _mockEmail = 'example@email.com';
  static const String _mockPassword = 'password123';

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _mockEmail);
    _passwordController = TextEditingController(text: _mockPassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ email và mật khẩu.');
      return;
    }

    await AppRoutes.replaceAll(context, AppRoutes.shell);
  }

  Future<void> _handleSocialLogin(String provider) async {
    _showMessage('Đăng nhập $provider thành công (mock).');
    await AppRoutes.replaceAll(context, AppRoutes.shell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.surfaceContainerLowest,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: FinzyTheme.spacingLg,
            vertical: FinzyTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _LoginHeader(
                title: _title,
                subtitle: _subtitle,
              ),
              const SizedBox(height: FinzyTheme.spacingXl),
              _LoginLabeledField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: FinzyTheme.outline,
                  size: FinzyTheme.iconSize,
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
              _LoginLabeledField(
                label: 'Mật khẩu',
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: FinzyTheme.outline,
                  size: FinzyTheme.iconSize,
                ),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: FinzyTheme.outline,
                    size: FinzyTheme.iconSize,
                  ),
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingSm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => AppRoutes.push(context, AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Quên mật khẩu?',
                    style: FinzyTheme.bodyMd.copyWith(
                      color: FinzyTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),
              PrimaryButton(
                label: 'Đăng nhập',
                onPressed: _handleLogin,
              ),
              const SizedBox(height: FinzyTheme.spacingLg),
              const _OrDivider(label: 'Hoặc đăng nhập bằng'),
              const SizedBox(height: FinzyTheme.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: _SocialLoginButton(
                      label: 'Google',
                      icon: const _GoogleIconPlaceholder(),
                      onPressed: () => _handleSocialLogin('Google'),
                    ),
                  ),
                  const SizedBox(width: FinzyTheme.spacingSm + 4),
                  Expanded(
                    child: _SocialLoginButton(
                      label: 'Apple',
                      icon: const Icon(
                        Icons.apple,
                        size: 22,
                        color: FinzyTheme.onSurface,
                      ),
                      onPressed: () => _handleSocialLogin('Apple'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FinzyTheme.spacingXl),
              _SignUpPrompt(
                onRegisterTap: () => AppRoutes.push(context, AppRoutes.register),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo tròn teal với icon ví ở phần header.
class _LoginHeader extends StatelessWidget {
  const _LoginHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: FinzyTheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: FinzyTheme.onPrimary,
            size: 32,
          ),
        ),
        const SizedBox(height: FinzyTheme.spacingLg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: FinzyTheme.headlineLgMobile.copyWith(
            color: FinzyTheme.onSurface,
          ),
        ),
        const SizedBox(height: FinzyTheme.spacingSm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Nhãn phía trên + ô nhập theo design (viền 12px, icon prefix).
class _LoginLabeledField extends StatelessWidget {
  const _LoginLabeledField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: FinzyTheme.spacingSm),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: FinzyTheme.bodyLg.copyWith(color: FinzyTheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: FinzyTheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: FinzyTheme.spacingMd,
              vertical: FinzyTheme.spacingSm + 4,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
              borderSide: const BorderSide(
                color: FinzyTheme.outlineVariant,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
              borderSide: const BorderSide(
                color: FinzyTheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Đường kẻ ngang với chữ ở giữa.
class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: FinzyTheme.outlineVariant,
            thickness: 1,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingSm + 4),
          child: Text(
            label,
            style: FinzyTheme.bodyMd.copyWith(
              color: FinzyTheme.outline,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: FinzyTheme.outlineVariant,
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

/// Nút đăng nhập mạng xã hội — viền xám, nền trắng.
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: FinzyTheme.surfaceContainerLowest,
        foregroundColor: FinzyTheme.onSurface,
        minimumSize: const Size.fromHeight(FinzyTheme.buttonMinHeight),
        side: const BorderSide(color: FinzyTheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: FinzyTheme.spacingSm),
          Text(
            label,
            style: FinzyTheme.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: FinzyTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder icon Google (chưa có asset SVG).
class _GoogleIconPlaceholder extends StatelessWidget {
  const _GoogleIconPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: FinzyTheme.outlineVariant),
      ),
      child: Text(
        'G',
        style: FinzyTheme.bodyMd.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4285F4),
          height: 1,
        ),
      ),
    );
  }
}

/// Footer: "Chưa có tài khoản? Đăng ký"
class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt({required this.onRegisterTap});

  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chưa có tài khoản? ',
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            'Đăng ký',
            style: FinzyTheme.bodyMd.copyWith(
              color: FinzyTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
