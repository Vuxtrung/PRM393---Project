import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'add_money_to_goal_screen.dart';
import 'withdraw_money_screen.dart';
import 'edit_goal_screen.dart';
import '../models/goal_model.dart';
import '../services/api_service.dart';
import 'savings_goals_screen.dart' show GoalUrgency;

class GoalDetailScreen extends StatefulWidget {
  final GoalModel goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late GoalModel _goal;
  bool _isLoading = false;
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getGoalById(_goal.id);
      if (mounted) {
        setState(() {
          _goal = GoalModel.fromJson(data['goal']);
          _transactions = data['transactions'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: _isLoading && _transactions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
    final daysLeft = _goal.deadline.difference(DateTime.now()).inDays;
    final GoalUrgency urgency = daysLeft < 7
        ? GoalUrgency.urgent
        : (daysLeft < 30 ? GoalUrgency.month : GoalUrgency.normal);

    Color iconColor;
    try {
      iconColor = Color(int.parse(_goal.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      iconColor = FinzyTheme.primary;
    }
    Color iconBg = iconColor.withValues(alpha: 0.1);

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
              color: iconBg,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: Icon(_goal.iconData, color: iconColor, size: 36),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          Text(
            _goal.name,
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
                urgency == GoalUrgency.urgent
                    ? '${_goal.deadline.day}/${_goal.deadline.month}/${_goal.deadline.year}'
                    : 'Hạn chót: ${_goal.deadline.day}/${_goal.deadline.month}/${_goal.deadline.year}',
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
                      _fmt(_goal.currentAmount),
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
                        _fmt(_goal.targetAmount),
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
    double percent = (_goal.targetAmount > 0)
        ? (_goal.currentAmount / _goal.targetAmount) * 100
        : 0;
    if (percent > 100) percent = 100;
    
    String percentText = percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1);

    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _RingPainter(progress: percent / 100),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentText%',
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
            'Bạn chỉ còn ${_fmt(max(0, _goal.targetAmount - _goal.currentAmount))}\nnữa để đạt mục tiêu!',
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
            onTap: () async {
              // Wait for user to add money, then refresh
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => AddMoneyToGoalScreen(
                        goalId: _goal.id, 
                        goalName: _goal.name,
                        currentAmount: _goal.currentAmount)),
              );
              if (mounted) {
                _fetchDetails();
              }
            },
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: _ActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Rút tiền',
            selected: false,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => WithdrawMoneyScreen(
                        goalId: _goal.id, 
                        goalName: _goal.name,
                        currentAmount: _goal.currentAmount)),
              );
              if (mounted) {
                _fetchDetails();
              }
            },
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingSm),
        Expanded(
          child: _ActionButton(
            icon: Icons.edit_outlined,
            label: 'Chỉnh sửa',
            selected: false,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => EditGoalScreen(goal: _goal)),
              );
              if (mounted) {
                _fetchDetails();
              }
            },
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // History Section
  // ---------------------------------------------------------------------------

  Widget _buildHistorySection() {
    if (_transactions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lịch sử tích lũy',
              style: FinzyTheme.headlineSm
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: FinzyTheme.spacingSm),
          const FinzyCard(
            padding: EdgeInsets.all(FinzyTheme.spacingLg),
            child: Center(
              child: Text('Chưa có giao dịch nào'),
            ),
          ),
        ],
      );
    }

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
            children: List.generate(_transactions.length, (i) {
              final isLast = i == _transactions.length - 1;
              final trx = _transactions[i];
              final amountNum = (trx['amount'] as num).toDouble();
              final date = DateTime.parse(trx['transactionDate'] ?? trx['createdAt']).toLocal();
              final isPositive = amountNum >= 0;
              final displayAmountStr = _fmt(amountNum.abs());

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
                            color: isPositive ? FinzyTheme.secondaryFixed : FinzyTheme.errorContainer,
                            borderRadius:
                                BorderRadius.circular(FinzyTheme.radiusMd),
                          ),
                          child: Icon(isPositive ? Icons.savings : Icons.account_balance_wallet,
                              color: isPositive ? FinzyTheme.onSecondaryFixed : FinzyTheme.error, size: 22),
                        ),
                        const SizedBox(width: FinzyTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trx['note'] ?? 'Giao dịch',
                                  style: FinzyTheme.bodyMd
                                      .copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('${date.hour}:${date.minute.toString().padLeft(2, '0')} • ${date.day}/${date.month}/${date.year}',
                                  style: FinzyTheme.labelMd),
                            ],
                          ),
                        ),
                        Text(
                          isPositive ? '+$displayAmountStr' : '-$displayAmountStr',
                          style: FinzyTheme.bodyMd.copyWith(
                              color: isPositive ? FinzyTheme.income : FinzyTheme.error,
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
            'Hãy giữ vững phong độ! Việc duy trì thói quen tiết kiệm đều đặn sẽ giúp bạn hoàn thành mục tiêu đúng hạn.',
            style: FinzyTheme.bodyMd
                .copyWith(color: FinzyTheme.onErrorContainer, height: 1.5),
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
// Supporting widgets
// ---------------------------------------------------------------------------

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
