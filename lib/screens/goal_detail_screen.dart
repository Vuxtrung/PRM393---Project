import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'add_money_to_goal_screen.dart';
import 'savings_goals_screen.dart';

class GoalDetailScreen extends StatelessWidget {
  final GoalItem goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero teal header card
              _buildHeroCard(context),

              Padding(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress ring
                    _buildProgressRing(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Action buttons
                    _buildActionButtons(context),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // History section
                    _buildHistorySection(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Motivational tip
                    _buildMotivationCard(),
                    const SizedBox(height: FinzyTheme.spacingMd),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Hero Card
  // ---------------------------------------------------------------------------

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      color: FinzyTheme.primary,
      padding: const EdgeInsets.fromLTRB(
        FinzyTheme.spacingMd,
        FinzyTheme.spacingMd,
        FinzyTheme.spacingMd,
        FinzyTheme.spacingLg,
      ),
      child: Column(
        children: [
          // App-bar row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: FinzyTheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  'Chi tiết mục tiêu',
                  textAlign: TextAlign.center,
                  style: FinzyTheme.headlineMd
                      .copyWith(color: FinzyTheme.onPrimary),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: FinzyTheme.onPrimary),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          // Piggy icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: goal.iconBg,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: Icon(goal.icon, color: goal.iconColor, size: 36),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          Text(
            goal.name,
            style: FinzyTheme.headlineLg
                .copyWith(color: FinzyTheme.onPrimary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: FinzyTheme.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: FinzyTheme.onPrimary, size: 14),
              const SizedBox(width: 4),
              Text(
                goal.urgency == GoalUrgency.urgent
                    ? goal.deadline
                    : 'Hạn chót: ${goal.deadline}',
                style: FinzyTheme.labelMd
                    .copyWith(color: FinzyTheme.onPrimary.withValues(alpha: 0.8)),
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingLg),

          // Hiện có / Mục tiêu row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HIỆN CÓ',
                      style: FinzyTheme.labelMd.copyWith(
                          color: FinzyTheme.onPrimary.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _fmt(goal.current),
                      style: FinzyTheme.headlineMd
                          .copyWith(color: FinzyTheme.onPrimary, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 1,
                  height: 40,
                  color: FinzyTheme.onPrimary.withValues(alpha: 0.3)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: FinzyTheme.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MỤC TIÊU',
                        style: FinzyTheme.labelMd.copyWith(
                            color: FinzyTheme.onPrimary.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _fmt(goal.target),
                        style: FinzyTheme.headlineMd.copyWith(
                            color: FinzyTheme.onPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Progress Ring
  // ---------------------------------------------------------------------------

  Widget _buildProgressRing() {
    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _RingPainter(progress: goal.percent / 100),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${goal.percent}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: FinzyTheme.onSurface,
                      ),
                    ),
                    const Text(
                      'TIẾN ĐỘ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: FinzyTheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),
          Text(
            'Bạn chỉ còn ${_fmt(goal.target - goal.current)}\nnữa để đạt mục tiêu!',
            textAlign: TextAlign.center,
            style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons
  // ---------------------------------------------------------------------------

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Nạp tiền',
            selected: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddMoneyToGoalScreen()),
            ),
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: _ActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Rút tiền',
            selected: false,
            onTap: () {},
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: _ActionButton(
            icon: Icons.edit_outlined,
            label: 'Chỉnh sửa',
            selected: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // History Section
  // ---------------------------------------------------------------------------

  Widget _buildHistorySection() {
    final items = [
      _HistoryItem(
          icon: Icons.savings,
          label: 'Nạp tiền vào heo',
          datetime: '12:30 • 15 Th10, 2024',
          amount: '+2.000.000đ'),
      _HistoryItem(
          icon: Icons.savings,
          label: 'Nạp tiền vào heo',
          datetime: '09:15 • 01 Th10, 2024',
          amount: '+5.000.000đ'),
      _HistoryItem(
          icon: Icons.savings,
          label: 'Thưởng lãi tích lũy',
          datetime: '00:01 • 30 Th09, 2024',
          amount: '+45.500đ'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lịch sử tích lũy',
                style: FinzyTheme.headlineSm
                    .copyWith(fontWeight: FontWeight.w700)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  foregroundColor: FinzyTheme.primary, padding: EdgeInsets.zero),
              child: Text('Xem tất cả',
                  style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: FinzyTheme.spacingSm),
        FinzyCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: FinzyTheme.secondaryFixed,
                            borderRadius:
                                BorderRadius.circular(FinzyTheme.radiusMd),
                          ),
                          child: Icon(items[i].icon,
                              color: FinzyTheme.onSecondaryFixed, size: 22),
                        ),
                        const SizedBox(width: FinzyTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(items[i].label,
                                  style: FinzyTheme.bodyMd
                                      .copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(items[i].datetime,
                                  style: FinzyTheme.labelMd),
                            ],
                          ),
                        ),
                        Text(
                          items[i].amount,
                          style: FinzyTheme.bodyMd.copyWith(
                              color: FinzyTheme.income,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Motivation Card
  // ---------------------------------------------------------------------------

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      decoration: BoxDecoration(
        color: FinzyTheme.errorContainer,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đừng bỏ cuộc!',
              style: FinzyTheme.bodyLg.copyWith(
                  color: FinzyTheme.onErrorContainer,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: FinzyTheme.spacingXs),
          Text(
            'Bạn đang thực hiện rất tốt. Chỉ cần nạp thêm 3 lần nữa với số tiền trung bình hiện tại, bạn sẽ đạt mục tiêu sớm hơn dự kiến 12 ngày.',
            style: FinzyTheme.bodyMd
                .copyWith(color: FinzyTheme.onErrorContainer, height: 1.5),
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

// ---------------------------------------------------------------------------
// Supporting widgets
// ---------------------------------------------------------------------------

class _HistoryItem {
  final IconData icon;
  final String label;
  final String datetime;
  final String amount;
  const _HistoryItem(
      {required this.icon,
      required this.label,
      required this.datetime,
      required this.amount});
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: FinzyTheme.spacingMd),
        decoration: BoxDecoration(
          color: selected ? FinzyTheme.primary : FinzyTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon,
                color:
                    selected ? FinzyTheme.onPrimary : FinzyTheme.onSurfaceVariant,
                size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: FinzyTheme.labelMd.copyWith(
                  color: selected
                      ? FinzyTheme.onPrimary
                      : FinzyTheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ring Painter
// ---------------------------------------------------------------------------

class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;
    const strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi,
      false,
      Paint()
        ..color = FinzyTheme.surfaceContainerHigh
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = FinzyTheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}
