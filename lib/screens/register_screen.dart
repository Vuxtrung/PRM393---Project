import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

/// Màn hình đăng ký — UI tĩnh theo design Finzy.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Mock data tĩnh — chưa kết nối Firebase hay xác thực thật.
  static const String _title = 'Tạo tài khoản mới';
  static const String _subtitle =
      'Bắt đầu hành trình quản lý tài chính thông minh';
  static const String _mockFullName = 'Nguyễn Văn A';
  static const String _mockEmail = 'example@email.com';
  static const String _mockPassword = 'password123';

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: _mockFullName);
    _emailController = TextEditingController(text: _mockEmail);
    _passwordController = TextEditingController(text: _mockPassword);
    _confirmPasswordController = TextEditingController(text: _mockPassword);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRegister() {
    if (!_agreedToTerms) {
      _showMessage('Vui lòng đồng ý với Điều khoản & Chính sách.');
      return;
    }
    _showMessage('Tạo tài khoản thành công (mock).');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: FinzyTheme.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FinzyTheme.onSurface),
          onPressed: () => AppRoutes.pop(context),
        ),
        title: Text(
          'Finzy',
          style: FinzyTheme.headlineSm.copyWith(
            color: FinzyTheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: FinzyTheme.spacingLg,
            vertical: FinzyTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _RegisterHeroImage(),
              const SizedBox(height: FinzyTheme.spacingLg),
              const _RegisterHeader(
                title: _title,
                subtitle: _subtitle,
              ),
              const SizedBox(height: FinzyTheme.spacingXl),
              _RegisterLabeledField(
                label: 'Họ và tên',
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: FinzyTheme.outline,
                  size: FinzyTheme.iconSize,
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
              _RegisterLabeledField(
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
              _RegisterLabeledField(
                label: 'Mật khẩu',
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: FinzyTheme.outline,
                  size: FinzyTheme.iconSize,
                ),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: FinzyTheme.outline,
                    size: FinzyTheme.iconSize,
                  ),
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
              _RegisterLabeledField(
                label: 'Xác nhận mật khẩu',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.lock_reset,
                  color: FinzyTheme.outline,
                  size: FinzyTheme.iconSize,
                ),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: FinzyTheme.outline,
                    size: FinzyTheme.iconSize,
                  ),
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
              _TermsCheckboxRow(
                value: _agreedToTerms,
                onChanged: (value) =>
                    setState(() => _agreedToTerms = value ?? false),
                onTermsTap: () =>
                    _showMessage('Mở Điều khoản & Chính sách (mock).'),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),
              _RegisterSubmitButton(onPressed: _handleRegister),
              const SizedBox(height: FinzyTheme.spacingXl),
              _LoginPrompt(
                onLoginTap: () => AppRoutes.pop(context),
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ảnh hero piggy bank — placeholder gradient khi chưa có asset.
class _RegisterHeroImage extends StatelessWidget {
  const _RegisterHeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(FinzyTheme.radiusXl),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FinzyTheme.inverseSurface,
                FinzyTheme.primaryContainer,
                FinzyTheme.surfaceContainerHigh,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.savings_outlined,
              size: 72,
              color: FinzyTheme.onPrimary.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiêu đề và mô tả phía dưới ảnh hero.
class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
class _RegisterLabeledField extends StatelessWidget {
  const _RegisterLabeledField({
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

/// Hàng checkbox + liên kết Điều khoản & Chính sách.
class _TermsCheckboxRow extends StatelessWidget {
  const _TermsCheckboxRow({
    required this.value,
    required this.onChanged,
    required this.onTermsTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: FinzyTheme.primary,
            side: const BorderSide(color: FinzyTheme.outlineVariant, width: 1.5),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: FinzyTheme.bodyMd.copyWith(
                color: FinzyTheme.onSurfaceVariant,
              ),
              children: [
                const TextSpan(text: 'Tôi đồng ý với '),
                TextSpan(
                  text: 'Điều khoản & Chính sách',
                  style: FinzyTheme.bodyMd.copyWith(
                    color: FinzyTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Nút CTA chính — chữ giữa, chevron bên phải.
class _RegisterSubmitButton extends StatelessWidget {
  const _RegisterSubmitButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: FinzyTheme.buttonMinHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'Tạo tài khoản',
              style: FinzyTheme.bodyLg.copyWith(
                fontWeight: FontWeight.w600,
                color: FinzyTheme.onPrimary,
              ),
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.chevron_right,
                color: FinzyTheme.onPrimary,
                size: FinzyTheme.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Footer: "Đã có tài khoản? Đăng nhập"
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: onLoginTap,
          child: Text(
            'Đăng nhập',
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
