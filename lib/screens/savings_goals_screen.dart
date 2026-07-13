import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import '../theme/app_theme.dart';
import 'create_new_goal_screen.dart';
import 'goal_detail_screen.dart';
import '../models/goal_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import 'notification_screen.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

enum GoalUrgency { normal, month, urgent }

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> with SingleTickerProviderStateMixin {
  List<GoalModel> _goals = [];
  bool _isLoading = true;
  int _unreadCount = 0;
  late AnimationController _bellController;
  late Animation<double> _bellAnimation;
  StreamSubscription<void>? _notifSub;

  @override
  void initState() {
    super.initState();
    _bellController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _bellAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.3).chain(CurveTween(curve: Curves.easeIn)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3).chain(CurveTween(curve: Curves.easeInOut)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3).chain(CurveTween(curve: Curves.easeInOut)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 1),
    ]).animate(_bellController);

    _notifSub = NotificationService.onNewTransaction.listen((_) {
      _fetchUnreadCount();
      _bellController.forward(from: 0.0);
    });

    _fetchGoals();
    _fetchUnreadCount();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final notifs = await NotificationService.getNotifications();
      int unread = 0;
      for (var n in notifs) {
        if (n['isRead'] != true) unread++;
      }
      if (mounted) {
        setState(() => _unreadCount = unread);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    _bellController.dispose();
    super.dispose();
  }

  Future<void> _fetchGoals() async {
    try {
      final goals = await ApiService.getGoals();
      goals.sort((a, b) => a.deadline.compareTo(b.deadline));
      if (mounted) {
        setState(() {
          _goals = goals;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi tải dữ liệu')),
        );
      }
    }
  }

  double get _totalSaved {
    return _goals.fold(0.0, (sum, item) => sum + item.currentAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchGoals,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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

                            if (_goals.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text('Chưa có mục tiêu nào. Hãy tạo mới!'),
                                ),
                              ),

                            // Goal cards
                            ..._goals.map(
                              (g) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: FinzyTheme.spacingSm),
                                child: _GoalCard(
                                  goal: g,
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        insetPadding: const EdgeInsets.all(
                                            FinzyTheme.spacingMd),
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              FinzyTheme.radiusLg),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          child: GoalDetailScreen(goal: g), // Need to adapt this too
                                        ),
                                      ),
                                    );
                                    // Refresh data when dialog closes
                                    _fetchGoals();
                                  },
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateNewGoalScreen()),
          );
          _fetchGoals();
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
          GestureDetector(
            onTap: () => AppRoutes.push(context, AppRoutes.profile),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: FinzyTheme.surfaceContainerHigh,
              ),
              child: const Icon(Icons.person,
                  color: FinzyTheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: FinzyTheme.spacingSm),
          Text('Finzy',
              style: FinzyTheme.headlineLg.copyWith(color: FinzyTheme.primary)),
          const Spacer(),
          Stack(
            children: [
              AnimatedBuilder(
                animation: _bellAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _bellAnimation.value,
                    alignment: Alignment.topCenter,
                    child: child,
                  );
                },
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: FinzyTheme.primary),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
                    );
                    _fetchUnreadCount();
                  },
                ),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: FinzyTheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _unreadCount > 9 ? '9+' : _unreadCount.toString(),
                      style: const TextStyle(
                        color: FinzyTheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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
            _fmt(_totalSaved),
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
                Text('Tuyệt vời!',
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

  String _fmt(double amount) {
    final s = amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '${s}đ';
  }
}

// ---------------------------------------------------------------------------
// Goal Card Widget
// ---------------------------------------------------------------------------

class _GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;

  const _GoalCard({required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double percent = (goal.targetAmount > 0)
        ? (goal.currentAmount / goal.targetAmount) * 100
        : 0;
    if (percent > 100) percent = 100;
    
    String percentText = percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1);

    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    final String timeLeft = daysLeft > 0 ? 'Còn $daysLeft ngày' : 'Hết hạn';
    final GoalUrgency urgency = daysLeft < 7
        ? GoalUrgency.urgent
        : (daysLeft < 30 ? GoalUrgency.month : GoalUrgency.normal);

    Color iconColor;
    try {
      iconColor = Color(int.parse(goal.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      iconColor = FinzyTheme.primary;
    }
    Color iconBg = iconColor.withValues(alpha: 0.1);

    Color badgeColor;
    Color badgeTextColor;
    IconData badgeIcon;

    switch (urgency) {
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                ),
                child: Icon(goal.iconData, color: iconColor, size: 24),
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
                    Text(timeLeft,
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
              style: FinzyTheme.headlineSm
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            urgency == GoalUrgency.urgent
                ? '${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}'
                : 'Dự kiến hoàn thành: ${goal.deadline.day}/${goal.deadline.month}/${goal.deadline.year}',
            style: FinzyTheme.labelMd,
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          // Amounts row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmt(goal.currentAmount),
                style: FinzyTheme.bodyLg.copyWith(
                  color: FinzyTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '/ ${_fmt(goal.targetAmount)}',
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
                widthFactor: percent / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: urgency == GoalUrgency.urgent
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
              '$percentText%',
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

  String _fmt(double amount) {
    final s = amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '${s}đ';
  }
}
