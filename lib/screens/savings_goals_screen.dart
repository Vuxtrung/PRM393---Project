import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'create_new_goal_screen.dart';
import 'goal_detail_screen.dart';

// ---------------------------------------------------------------------------
// Mock Data
// ---------------------------------------------------------------------------

enum GoalUrgency { normal, month, urgent }

class GoalItem {
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String deadline;
  final String timeLeft;
  final GoalUrgency urgency;
  final int current;
  final int target;
  final int percent;

  const GoalItem({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.deadline,
    required this.timeLeft,
    required this.urgency,
    required this.current,
    required this.target,
    required this.percent,
  });
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<GoalItem> _goals = [
    GoalItem(
      name: 'Mua iPhone 16 Pro',
      icon: Icons.phone_iphone,
      iconColor: Color(0xFF6E7979),
      iconBg: Color(0xFFEBEEEE),
      deadline: '25/12/2024',
      timeLeft: 'Còn 15 ngày',
      urgency: GoalUrgency.normal,
      current: 25000000,
      target: 35000000,
      percent: 71,
    ),
    GoalItem(
      name: 'Du lịch Nhật Bản',
      icon: Icons.flight_takeoff,
      iconColor: Color(0xFFF97316),
      iconBg: Color(0xFFFFF0E6),
      deadline: '15/04/2025',
      timeLeft: 'Còn 4 tháng',
      urgency: GoalUrgency.month,
      current: 12500000,
      target: 40000000,
      percent: 31,
    ),
    GoalItem(
      name: 'MacBook Air M3',
      icon: Icons.laptop_mac,
      iconColor: Color(0xFF8B5CF6),
      iconBg: Color(0xFFF5F3FF),
      deadline: 'Sắp đến hạn mục tiêu',
      timeLeft: 'Còn 3 ngày',
      urgency: GoalUrgency.urgent,
      current: 28000000,
      target: 30000000,
      percent: 93,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero total card
                    _buildTotalCard(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mục tiêu tiết kiệm',
                          style: FinzyTheme.headlineMd
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: FinzyTheme.primary,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('Xem tất cả',
                              style: FinzyTheme.bodyMd
                                  .copyWith(color: FinzyTheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: FinzyTheme.spacingSm),

                    // Goal cards
                    ..._goals.map(
                      (g) => Padding(
                        padding: const EdgeInsets.only(bottom: FinzyTheme.spacingSm),
                        child: _GoalCard(
                          goal: g,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GoalDetailScreen(goal: g),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Tip banner
                    _buildTipBanner(),
                    const SizedBox(height: 80), // space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newGoal = await Navigator.of(context).push<GoalItem>(
            MaterialPageRoute(builder: (_) => const CreateNewGoalScreen()),
          );
          if (newGoal != null) {
            setState(() {
              _goals.add(newGoal);
            });
          }
        },
        backgroundColor: FinzyTheme.primary,
        foregroundColor: FinzyTheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinzyTheme.spacingMd,
        vertical: FinzyTheme.spacingSm,
      ),
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

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      decoration: BoxDecoration(
        color: FinzyTheme.primary,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TỔNG TÍCH LŨY HIỆN TẠI',
            style: FinzyTheme.labelMd.copyWith(
              color: FinzyTheme.onPrimary.withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: FinzyTheme.spacingSm),
          Text(
            '42.500.000đ',
            style: FinzyTheme.displayCurrency.copyWith(
              color: FinzyTheme.onPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: FinzyTheme.primaryContainer,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up,
                    size: 16, color: FinzyTheme.onPrimary),
                const SizedBox(width: 4),
                Text('+12% tháng này',
                    style: FinzyTheme.labelMd
                        .copyWith(color: FinzyTheme.onPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipBanner() {
    return Container(
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: FinzyTheme.primary,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: const Icon(Icons.lightbulb_outline,
                color: FinzyTheme.onPrimary, size: 22),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mẹo tích lũy nhanh',
                    style: FinzyTheme.bodyMd
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  'Bật tính năng "Làm tròn chi tiêu" để tự động tích lũy số dư lẻ vào Heo đất.',
                  style: FinzyTheme.labelMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Goal Card Widget
// ---------------------------------------------------------------------------

class _GoalCard extends StatelessWidget {
  final GoalItem goal;
  final VoidCallback onTap;

  const _GoalCard({required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color badgeTextColor;
    IconData badgeIcon;

    switch (goal.urgency) {
      case GoalUrgency.urgent:
        badgeColor = FinzyTheme.errorContainer;
        badgeTextColor = FinzyTheme.error;
        badgeIcon = Icons.warning_amber_rounded;
        break;
      case GoalUrgency.month:
        badgeColor = FinzyTheme.surfaceContainerHigh;
        badgeTextColor = FinzyTheme.onSurfaceVariant;
        badgeIcon = Icons.calendar_today_outlined;
        break;
      case GoalUrgency.normal:
        badgeColor = FinzyTheme.surfaceContainerHigh;
        badgeTextColor = FinzyTheme.onSurfaceVariant;
        badgeIcon = Icons.alarm_outlined;
        break;
    }

    return FinzyCard(
      onTap: onTap,
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: goal.iconBg,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                ),
                child: Icon(goal.icon, color: goal.iconColor, size: 24),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 13, color: badgeTextColor),
                    const SizedBox(width: 4),
                    Text(goal.timeLeft,
                        style: FinzyTheme.labelMd
                            .copyWith(color: badgeTextColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          // Goal name
          Text(goal.name,
              style: FinzyTheme.headlineSm.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            goal.urgency == GoalUrgency.urgent
                ? goal.deadline
                : 'Dự kiến hoàn thành: ${goal.deadline}',
            style: FinzyTheme.labelMd,
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          // Amounts row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(goal.current),
                style: FinzyTheme.bodyLg.copyWith(
                  color: FinzyTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '/ ${_fmt(goal.target)}',
                style: FinzyTheme.labelMd,
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingSm),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: FinzyTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                ),
              ),
              FractionallySizedBox(
                widthFactor: goal.percent / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: goal.urgency == GoalUrgency.urgent
                        ? FinzyTheme.error
                        : FinzyTheme.primary,
                    borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingXs),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${goal.percent}%',
              style: FinzyTheme.labelMd.copyWith(
                color: FinzyTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int amount) {
    final s = amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '${s}đ';
  }
}
