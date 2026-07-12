import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String _name = '';
  String _email = '';
  String _createdAt = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await AuthService.getProfile();
    if (mounted) {
      if (result['success'] == true) {
        setState(() {
          _name = result['data']['name'] ?? '';
          _email = result['data']['email'] ?? '';
          if (result['data']['createdAt'] != null) {
            final date = DateTime.parse(result['data']['createdAt']).toLocal();
            _createdAt = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
          }
          _isLoading = false;
        });
      } else {
        // If fail to get profile, maybe token expired, logout
        _handleLogout();
      }
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      AppRoutes.replaceAll(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ người dùng'),
        backgroundColor: FinzyTheme.surfaceContainerLowest,
        elevation: 0,
        foregroundColor: FinzyTheme.onSurface,
      ),
      backgroundColor: FinzyTheme.surfaceContainerLowest,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(FinzyTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: FinzyTheme.spacingXl),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: FinzyTheme.surfaceContainerHigh,
                    ),
                    child: const Icon(Icons.person,
                        size: 60, color: FinzyTheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: FinzyTheme.spacingMd),
                  Text(
                    _name,
                    style: FinzyTheme.headlineLg,
                  ),
                  const SizedBox(height: FinzyTheme.spacingXs),
                  Text(
                    _email,
                    style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.outline),
                  ),
                  if (_createdAt.isNotEmpty) ...[
                    const SizedBox(height: FinzyTheme.spacingXs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: FinzyTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                      ),
                      child: Text('Tham gia: $_createdAt', style: FinzyTheme.labelMd),
                    ),
                  ],
                  const SizedBox(height: FinzyTheme.spacingXl),

                  // Actions
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Đổi mật khẩu',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Cài đặt thông báo',
                    onTap: () {},
                  ),
                  const SizedBox(height: FinzyTheme.spacingXl),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    textColor: FinzyTheme.error,
                    iconColor: FinzyTheme.error,
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (iconColor ?? FinzyTheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? FinzyTheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: FinzyTheme.bodyLg.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor ?? FinzyTheme.onSurface,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: FinzyTheme.onSurfaceVariant),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd, vertical: 4),
    );
  }
}
