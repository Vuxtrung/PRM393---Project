import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Mock data models
// ---------------------------------------------------------------------------

class _SpendingCategory {
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final int transactionCount;
  final double amount;
  final double ratio; // 0.0–1.0 relative to max spending

  const _SpendingCategory({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.transactionCount,
    required this.amount,
    required this.ratio,
  });
}

const List<_SpendingCategory> _mockCategories = [
  _SpendingCategory(
    name: 'Ăn uống',
    icon: Icons.restaurant,
    iconColor: Color(0xFFF97316),
    iconBg: Color(0xFFFFF0E6),
    transactionCount: 12,
    amount: 8250000,
    ratio: 0.55,
  ),
  _SpendingCategory(
    name: 'Di chuyển',
    icon: Icons.directions_car,
    iconColor: Color(0xFF3B82F6),
    iconBg: Color(0xFFEFF6FF),
    transactionCount: 24,
    amount: 4100000,
    ratio: 0.27,
  ),
  _SpendingCategory(
    name: 'Mua sắm',
    icon: Icons.shopping_bag,
    iconColor: Color(0xFF8B5CF6),
    iconBg: Color(0xFFF5F3FF),
    transactionCount: 8,
    amount: 12050000,
    ratio: 0.80,
  ),
];

// ---------------------------------------------------------------------------
// Statistics Overview Screen
// ---------------------------------------------------------------------------

class StatisticsOverviewScreen extends StatefulWidget {
  const StatisticsOverviewScreen({super.key});

  @override
  State<StatisticsOverviewScreen> createState() =>
      _StatisticsOverviewScreenState();
}

class _StatisticsOverviewScreenState extends State<StatisticsOverviewScreen> {
  int _selectedTabIndex = 0; // 0: Biểu đồ, 1: Theo danh mục, 2: So sánh
  String _currentMonth = 'Tháng 6, 2025';

  final List<String> _tabs = ['Biểu đồ', 'Theo danh mục', 'So sánh'];

  // Mock weekly bar chart data: [thu, chi] per day Mon–Sun
  final List<Map<String, double>> _weeklyData = const [
    {'thu': 4.5, 'chi': 2.8},
    {'thu': 2.1, 'chi': 3.5},
    {'thu': 6.0, 'chi': 1.2},
    {'thu': 3.3, 'chi': 4.0},
    {'thu': 5.8, 'chi': 3.1},
    {'thu': 1.5, 'chi': 5.5},
    {'thu': 7.2, 'chi': 2.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar area
            _buildAppBar(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month navigator
                    _buildMonthNavigator(),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Summary row: Tổng thu / Tổng chi / Số dư
                    _buildSummaryRow(),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Tab bar
                    _buildTabBar(),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Chart section
                    _buildChartCard(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Top spending categories
                    _buildTopSpendingSection(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Savings goal card
                    _buildSavingsGoalCard(),
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

  // ---------------------------------------------------------------------------
  // App Bar
  // ---------------------------------------------------------------------------

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinzyTheme.spacingMd,
        vertical: FinzyTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: FinzyTheme.surfaceContainerHigh,
            ),
            clipBehavior: Clip.antiAlias,
            child: const Icon(Icons.person, color: FinzyTheme.onSurfaceVariant),
          ),
          const SizedBox(width: FinzyTheme.spacingSm),
          Text('Finzy', style: FinzyTheme.headlineLg.copyWith(color: FinzyTheme.primary)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: FinzyTheme.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Month Navigator
  // ---------------------------------------------------------------------------

  Widget _buildMonthNavigator() {
    return FinzyCard(
      padding: const EdgeInsets.symmetric(
        horizontal: FinzyTheme.spacingMd,
        vertical: FinzyTheme.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: FinzyTheme.onSurfaceVariant),
            onPressed: () {
              // Navigate previous month (mock)
            },
          ),
          Column(
            children: [
              Text(
                _currentMonth,
                style: FinzyTheme.headlineSm.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                'Thống kê tháng hiện tại',
                style: FinzyTheme.labelMd.copyWith(color: FinzyTheme.onSurfaceVariant),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: FinzyTheme.onSurfaceVariant),
            onPressed: () {
              // Navigate next month (mock)
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary Row
  // ---------------------------------------------------------------------------

  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            label: 'Tổng thu',
            amount: '45.0M',
            color: FinzyTheme.income,
          ),
        ),
        _buildSummaryDivider(),
        Expanded(
          child: _buildSummaryItem(
            label: 'Tổng chi',
            amount: '28.4M',
            color: FinzyTheme.expense,
          ),
        ),
        _buildSummaryDivider(),
        Expanded(
          child: _buildSummaryItem(
            label: 'Số dư',
            amount: '16.6M',
            color: FinzyTheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: FinzyTheme.spacingMd,
        horizontal: FinzyTheme.spacingSm,
      ),
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
        boxShadow: FinzyTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: FinzyTheme.labelMd),
          const SizedBox(height: FinzyTheme.spacingXs),
          Text(
            amount,
            style: FinzyTheme.headlineSm.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: FinzyTheme.spacingSm),
          Container(
            height: 3,
            width: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDivider() {
    return const SizedBox(width: FinzyTheme.spacingSm);
  }

  // ---------------------------------------------------------------------------
  // Tab Bar
  // ---------------------------------------------------------------------------

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingXs),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? FinzyTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: FinzyTheme.bodyMd.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? FinzyTheme.onPrimary : FinzyTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Weekly Bar Chart Card
  // ---------------------------------------------------------------------------

  Widget _buildChartCard() {
    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biểu đồ hàng tuần',
                    style: FinzyTheme.headlineSm.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'So sánh thu nhập và chi tiêu',
                    style: FinzyTheme.labelMd,
                  ),
                ],
              ),
              // Legend
              Row(
                children: [
                  _buildLegendDot(FinzyTheme.primary, 'THU'),
                  const SizedBox(width: FinzyTheme.spacingSm),
                  _buildLegendDot(FinzyTheme.secondaryContainer, 'CHI'),
                ],
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingLg),

          // Bar Chart
          SizedBox(
            height: 160,
            child: _buildBarChart(),
          ),
          const SizedBox(height: FinzyTheme.spacingSm),

          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('T2'), Text('T3'), Text('T4'), Text('T5'),
              Text('T6'), Text('T7'), Text('CN'),
            ].map((t) => Text(
              (t as Text).data!,
              style: FinzyTheme.labelMd.copyWith(color: FinzyTheme.onSurfaceVariant),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: FinzyTheme.labelMd),
      ],
    );
  }

  Widget _buildBarChart() {
    final maxVal = _weeklyData.fold<double>(0, (prev, d) {
      final m = max(d['thu']!, d['chi']!);
      return m > prev ? m : prev;
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weeklyData.map((day) {
        final thuRatio = day['thu']! / maxVal;
        final chiRatio = day['chi']! / maxVal;
        return _buildBarPair(thuRatio: thuRatio, chiRatio: chiRatio);
      }).toList(),
    );
  }

  Widget _buildBarPair({required double thuRatio, required double chiRatio}) {
    const maxHeight = 140.0;
    const barWidth = 14.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Thu bar (primary/teal)
        Container(
          width: barWidth,
          height: max(4, maxHeight * thuRatio),
          decoration: BoxDecoration(
            color: FinzyTheme.primary,
            borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
          ),
        ),
        const SizedBox(width: 3),
        // Chi bar (amber)
        Container(
          width: barWidth,
          height: max(4, maxHeight * chiRatio),
          decoration: BoxDecoration(
            color: FinzyTheme.secondaryContainer,
            borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Top Spending Categories
  // ---------------------------------------------------------------------------

  Widget _buildTopSpendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top chi tiêu',
              style: FinzyTheme.headlineMd.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: FinzyTheme.primary,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'Xem tất cả',
                style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: FinzyTheme.spacingSm),

        // Category list
        ...List.generate(_mockCategories.length, (i) {
          final cat = _mockCategories[i];
          return Column(
            children: [
              _buildCategoryItem(cat),
              if (i < _mockCategories.length - 1)
                const SizedBox(height: FinzyTheme.spacingSm),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildCategoryItem(_SpendingCategory cat) {
    // Format amount to Vietnamese style: -8,250,000đ
    final amountStr = _formatVnd(-cat.amount.toInt());

    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Column(
        children: [
          Row(
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cat.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(cat.icon, color: cat.iconColor, size: 24),
              ),
              const SizedBox(width: FinzyTheme.spacingMd),

              // Name and count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name.toUpperCase(),
                      style: FinzyTheme.bodyMd.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${cat.transactionCount} giao dịch',
                      style: FinzyTheme.labelMd,
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                amountStr,
                style: FinzyTheme.bodyLg.copyWith(
                  color: FinzyTheme.expense,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: FinzyTheme.spacingSm),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FinzyTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                ),
              ),
              FractionallySizedBox(
                widthFactor: cat.ratio,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: cat.iconColor,
                    borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
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
  // Savings Goal Card
  // ---------------------------------------------------------------------------

  Widget _buildSavingsGoalCard() {
    const double current = 21600000;
    const double target = 30000000;
    final double progress = current / target; // 0.72

    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
        boxShadow: FinzyTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Row(
        children: [
          // Goal icon placeholder (amber box)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: FinzyTheme.secondaryContainer,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: const Icon(Icons.savings, color: Colors.white, size: 32),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),

          // Goal info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Heo Đất: Mua iPhone 16',
                      style: FinzyTheme.bodyLg.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: FinzyTheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: FinzyTheme.spacingXs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đã đạt ${(progress * 100).round()}%',
                      style: FinzyTheme.labelMd,
                    ),
                    Text(
                      '${_formatVndPositive(current.toInt())} / 30M',
                      style: FinzyTheme.labelMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: FinzyTheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FinzyTheme.spacingSm),

                // Progress bar
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FinzyTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: FinzyTheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _formatVnd(int amount) {
    final isNegative = amount < 0;
    final abs = amount.abs();
    final str = abs.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}${str}đ';
  }

  String _formatVndPositive(int amount) {
    final str = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${str}đ';
  }
}
