import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    final result = await AuthService.changePassword(currentPassword, newPassword);
    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: FinzyTheme.surfaceContainerLowest,
        elevation: 0,
        foregroundColor: FinzyTheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FinzyTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mật khẩu hiện tại', style: FinzyTheme.labelMd),
            const SizedBox(height: FinzyTheme.spacingSm),
            _buildPasswordField(_currentPasswordController, 'Nhập mật khẩu hiện tại', _obscureCurrent, () {
              setState(() => _obscureCurrent = !_obscureCurrent);
            }),
            const SizedBox(height: FinzyTheme.spacingLg),

            Text('Mật khẩu mới', style: FinzyTheme.labelMd),
            const SizedBox(height: FinzyTheme.spacingSm),
            _buildPasswordField(_newPasswordController, 'Nhập mật khẩu mới', _obscureNew, () {
              setState(() => _obscureNew = !_obscureNew);
            }),
            const SizedBox(height: FinzyTheme.spacingLg),

            Text('Xác nhận mật khẩu mới', style: FinzyTheme.labelMd),
            const SizedBox(height: FinzyTheme.spacingSm),
            _buildPasswordField(_confirmPasswordController, 'Nhập lại mật khẩu mới', _obscureConfirm, () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            }),
            const SizedBox(height: FinzyTheme.spacingXl),

            SizedBox(
              width: double.infinity,
              height: FinzyTheme.buttonMinHeight,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FinzyTheme.primary,
                  foregroundColor: FinzyTheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                  ),
                ),
                child: Text('Lưu thay đổi',
                    style: FinzyTheme.bodyLg.copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscureText, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: FinzyTheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
          borderSide: BorderSide(color: FinzyTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
          borderSide: BorderSide(color: FinzyTheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
          borderSide: BorderSide(color: FinzyTheme.primary),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: FinzyTheme.onSurfaceVariant,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
