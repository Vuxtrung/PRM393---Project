import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/goal_model.dart';
import '../services/api_service.dart';
import 'goal_detail_screen.dart';

class CompletedGoalsScreen extends StatefulWidget {
  const CompletedGoalsScreen({super.key});

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  List<GoalModel> _completedGoals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompletedGoals();
  }

  Future<void> _fetchCompletedGoals() async {
    try {
      final goals = await ApiService.getGoals();
      // Lọc các mục tiêu đã hoàn thành
      final completed = goals.where((g) => g.currentAmount >= g.targetAmount || g.status == 'completed').toList();
      completed.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (mounted) {
        setState(() {
          _completedGoals = completed;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi tải dữ liệu')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      appBar: AppBar(
        backgroundColor: FinzyTheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Mục tiêu đã hoàn thành',
          style: FinzyTheme.headlineMd.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FinzyTheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: FinzyTheme.surfaceContainerHigh, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _completedGoals.isEmpty
                ? const Center(child: Text('Chưa có mục tiêu nào hoàn thành'))
                : RefreshIndicator(
                    onRefresh: _fetchCompletedGoals,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                      itemCount: _completedGoals.length,
                      separatorBuilder: (context, index) => const SizedBox(height: FinzyTheme.spacingMd),
                      itemBuilder: (context, index) {
                        final goal = _completedGoals[index];
                        return _CompletedGoalCard(
                          goal: goal,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => GoalDetailScreen(goal: goal)),
                            );
                            _fetchCompletedGoals();
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class _CompletedGoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;

  const _CompletedGoalCard({required this.goal, required this.onTap});

  String _fmt(double amount) {
    final s = amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '${s}đ';
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    try {
      iconColor = Color(int.parse(goal.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      iconColor = FinzyTheme.primary;
    }
    Color iconBg = iconColor.withValues(alpha: 0.1);

    return FinzyCard(
      onTap: onTap,
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: Icon(goal.iconData, color: iconColor, size: 28),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.name,
                        style: FinzyTheme.headlineSm.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: FinzyTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        goal.pigTier,
                        style: FinzyTheme.labelMd.copyWith(
                          color: FinzyTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Đã đạt: ${_fmt(goal.targetAmount)}',
                  style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                Text('Hoàn thành', style: FinzyTheme.labelMd.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
