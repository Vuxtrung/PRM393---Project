import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool enabled;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Periodic reminders
  final List<bool> _periodicEnabled = [true, true];
  // Finance & savings
  final List<bool> _financeEnabled = [false, true];

  final List<_NotificationItem> _periodicItems = const [
    _NotificationItem(
      icon: Icons.receipt_long_outlined,
      iconColor: Color(0xFF3B82F6),
      iconBg: Color(0xFFEFF6FF),
      title: 'Nhắc nhở chi tiêu hàng ngày',
      subtitle: 'Lúc 8:00 PM mỗi ngày',
      enabled: true,
    ),
    _NotificationItem(
      icon: Icons.bar_chart_outlined,
      iconColor: Color(0xFFF97316),
      iconBg: Color(0xFFFFF0E6),
      title: 'Tóm tắt tuần',
      subtitle: 'Chủ nhật lúc 9:00 AM',
      enabled: true,
    ),
  ];

  final List<_NotificationItem> _financeItems = const [
    _NotificationItem(
      icon: Icons.savings_outlined,
      iconColor: Color(0xFF22C55E),
      iconBg: Color(0xFFF0FDF4),
      title: 'Nhắc nạp tiền Heo',
      subtitle: '10:00 AM Thứ Hai',
      enabled: false,
    ),
    _NotificationItem(
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFEF4444),
      iconBg: Color(0xFFFEF2F2),
      title: 'Cảnh báo vượt ngân sách',
      subtitle: 'Khi đạt 80% hạn mức',
      enabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FinzyTheme.spacingSm,
                  vertical: FinzyTheme.spacingXs),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Cài đặt thông báo',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd.copyWith(
                          color: FinzyTheme.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: FinzyTheme.primary, width: 2),
                      borderRadius:
                          BorderRadius.circular(FinzyTheme.radiusSm),
                    ),
                    child: const Icon(Icons.phone_iphone,
                        color: FinzyTheme.primary, size: 22),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero banner
                    _buildHeroBanner(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Periodic reminders section
                    FinzySectionLabel('Lời Nhắc Định Kỳ'),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    FinzyCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: List.generate(_periodicItems.length, (i) {
                          final isLast = i == _periodicItems.length - 1;
                          return Column(
                            children: [
                              _NotificationRow(
                                item: _periodicItems[i],
                                value: _periodicEnabled[i],
                                onChanged: (v) => setState(
                                    () => _periodicEnabled[i] = v),
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
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Finance section
                    FinzySectionLabel('Tài Chính & Tiết Kiệm'),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    FinzyCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: List.generate(_financeItems.length, (i) {
                          final isLast = i == _financeItems.length - 1;
                          return Column(
                            children: [
                              _NotificationRow(
                                item: _financeItems[i],
                                value: _financeEnabled[i],
                                onChanged: (v) => setState(
                                    () => _financeEnabled[i] = v),
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
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Footnote
                    Center(
                      child: Text(
                        'Bạn sẽ nhận được các thông báo này qua ứng dụng và email đã đăng ký.',
                        style: FinzyTheme.labelMd.copyWith(
                            color: FinzyTheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: FinzyTheme.surfaceContainerLowest,
              shape: BoxShape.circle,
              boxShadow: FinzyTheme.cardShadow,
            ),
            child: const Icon(Icons.notifications_active,
                color: FinzyTheme.primary, size: 36),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),
          Text(
            'Quản lý cách Finzy liên lạc với bạn',
            style: FinzyTheme.bodyLg.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final _NotificationItem item;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationRow({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style:
                        FinzyTheme.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: FinzyTheme.labelMd.copyWith(
                    color: value
                        ? FinzyTheme.primary
                        : FinzyTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: FinzyTheme.primary,
            activeTrackColor: FinzyTheme.primaryFixed,
          ),
        ],
      ),
    );
  }
}
