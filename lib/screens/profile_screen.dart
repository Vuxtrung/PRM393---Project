import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'manage_categories_screen.dart';
import 'notification_settings_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: FinzyTheme.spacingMd),

              // Avatar + name + email
              _buildProfileHeader(),
              const SizedBox(height: FinzyTheme.spacingLg),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
                child: _buildStatsRow(),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),

              // Account settings group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
                child: Column(
                  children: [
                    _buildMenuGroup(
                      context: context,
                      items: [
                        _MenuItem(
                          icon: Icons.person_outline,
                          iconColor: const Color(0xFF3B82F6),
                          iconBg: const Color(0xFFEFF6FF),
                          label: 'Thông tin cá nhân',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.lock_outline,
                          iconColor: const Color(0xFFF97316),
                          iconBg: const Color(0xFFFFF0E6),
                          label: 'Đổi mật khẩu',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.category_outlined,
                          iconColor: const Color(0xFF22C55E),
                          iconBg: const Color(0xFFF0FDF4),
                          label: 'Quản lý danh mục',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ManageCategoriesScreen()),
                          ),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          iconColor: const Color(0xFF8B5CF6),
                          iconBg: const Color(0xFFF5F3FF),
                          label: 'Quản lý thông báo',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const NotificationSettingsScreen()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    _buildMenuGroup(
                      context: context,
                      items: [
                        _MenuItem(
                          icon: Icons.language,
                          iconColor: const Color(0xFF6E7979),
                          iconBg: FinzyTheme.surfaceContainerHigh,
                          label: 'Ngôn ngữ',
                          subtitle: 'Tiếng Việt',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.help_outline,
                          iconColor: const Color(0xFF22C55E),
                          iconBg: const Color(0xFFF0FDF4),
                          label: 'Trợ giúp',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Sign out
                    FinzyCard(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FinzyTheme.errorContainer,
                              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                            ),
                            child: const Icon(Icons.logout,
                                color: FinzyTheme.error, size: 20),
                          ),
                          const SizedBox(width: FinzyTheme.spacingMd),
                          Text(
                            'Đăng xuất',
                            style: FinzyTheme.bodyLg.copyWith(
                                color: FinzyTheme.error,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    Text(
                      'Phiên bản 2.4.0 (Build 108)',
                      style: FinzyTheme.labelMd
                          .copyWith(color: FinzyTheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: FinzyTheme.spacingMd, vertical: FinzyTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: FinzyTheme.surfaceContainerHigh,
            ),
            child: const Icon(Icons.person, color: FinzyTheme.onSurfaceVariant),
          ),
          const SizedBox(width: FinzyTheme.spacingSm),
          Text('Finzy',
              style: FinzyTheme.headlineLg.copyWith(color: FinzyTheme.primary)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: FinzyTheme.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: FinzyTheme.surfaceContainerHigh,
                border: Border.all(color: FinzyTheme.primary, width: 2),
              ),
              child: const Icon(Icons.person, size: 48, color: FinzyTheme.primary),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: FinzyTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, color: FinzyTheme.onPrimary, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: FinzyTheme.spacingMd),
        Text('Vũ Đức Trung',
            style: FinzyTheme.headlineMd.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('@trungduc.07122005',
            style:
                FinzyTheme.bodyMd.copyWith(color: FinzyTheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: FinzyCard(
            padding: const EdgeInsets.all(FinzyTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        size: 20, color: FinzyTheme.primary),
                    const SizedBox(width: 6),
                    Text('Số giao dịch', style: FinzyTheme.labelMd),
                  ],
                ),
                const SizedBox(height: FinzyTheme.spacingSm),
                Text('1,248',
                    style: FinzyTheme.headlineLg
                        .copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('+12 tháng này',
                    style: FinzyTheme.labelMd
                        .copyWith(color: FinzyTheme.income)),
              ],
            ),
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: FinzyCard(
            padding: const EdgeInsets.all(FinzyTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined,
                        size: 20, color: FinzyTheme.secondary),
                    const SizedBox(width: 6),
                    Text('Tháng sử dụng', style: FinzyTheme.labelMd),
                  ],
                ),
                const SizedBox(height: FinzyTheme.spacingSm),
                Text('24',
                    style: FinzyTheme.headlineLg.copyWith(
                        fontWeight: FontWeight.w800,
                        color: FinzyTheme.secondary)),
                const SizedBox(height: 2),
                Text('Từ T05/2022', style: FinzyTheme.labelMd),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup(
      {required BuildContext context, required List<_MenuItem> items}) {
    return FinzyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: items[i].onTap,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(i == 0 ? FinzyTheme.radiusLg : 0),
                  topRight: Radius.circular(i == 0 ? FinzyTheme.radiusLg : 0),
                  bottomLeft: Radius.circular(
                      isLast ? FinzyTheme.radiusLg : 0),
                  bottomRight: Radius.circular(
                      isLast ? FinzyTheme.radiusLg : 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: items[i].iconBg,
                          borderRadius:
                              BorderRadius.circular(FinzyTheme.radiusMd),
                        ),
                        child: Icon(items[i].icon,
                            color: items[i].iconColor, size: 20),
                      ),
                      const SizedBox(width: FinzyTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[i].label,
                                style: FinzyTheme.bodyLg
                                    .copyWith(fontWeight: FontWeight.w500)),
                            if (items[i].subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(items[i].subtitle!,
                                  style: FinzyTheme.labelMd),
                            ],
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: FinzyTheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: FinzyTheme.spacingMd,
                    endIndent: FinzyTheme.spacingMd),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    this.subtitle,
    required this.onTap,
  });
}
