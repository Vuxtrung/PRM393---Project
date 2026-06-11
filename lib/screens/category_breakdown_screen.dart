import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Mock data model
// ---------------------------------------------------------------------------

class _CategoryData {
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color chartColor;
  final int percent; // 0–100
  final int amount;  // in VNĐ

  const _CategoryData({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.chartColor,
    required this.percent,
    required this.amount,
  });
}

const List<_CategoryData> _mockCategories = [
  _CategoryData(
    name: 'Ăn uống',
    icon: Icons.restaurant,
    iconColor: Color(0xFFF97316),
    iconBg: Color(0xFFFFF0E6),
    chartColor: Color(0xFFF97316),
    percent: 45,
    amount: 3802500,
  ),
  _CategoryData(
    name: 'Di chuyển',
    icon: Icons.directions_car,
    iconColor: Color(0xFF3B82F6),
    iconBg: Color(0xFFEFF6FF),
    chartColor: Color(0xFF3B82F6),
    percent: 25,
    amount: 2112500,
  ),
  _CategoryData(
    name: 'Mua sắm',
    icon: Icons.shopping_bag,
    iconColor: Color(0xFF8B5CF6),
    iconBg: Color(0xFFF5F3FF),
    chartColor: Color(0xFF8B5CF6),
    percent: 20,
    amount: 1690000,
  ),
  _CategoryData(
    name: 'Khác',
    icon: Icons.category,
    iconColor: Color(0xFF22C55E),
    iconBg: Color(0xFFF0FDF4),
    chartColor: Color(0xFF22C55E),
    percent: 10,
    amount: 845000,
  ),
];

// ---------------------------------------------------------------------------
// Category Breakdown Screen
// ---------------------------------------------------------------------------

class CategoryBreakdownScreen extends StatefulWidget {
  const CategoryBreakdownScreen({super.key});

  @override
  State<CategoryBreakdownScreen> createState() =>
      _CategoryBreakdownScreenState();
}

class _CategoryBreakdownScreenState extends State<CategoryBreakdownScreen> {
  int _selectedPeriodIndex = 0; // 0: Tháng này, 1: Tháng trước, 2: Tùy chỉnh

  final List<String> _periods = ['Tháng này', 'Tháng trước', 'Tùy chỉnh'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Period filter tabs
                    _buildPeriodFilter(),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Donut chart card
                    _buildDonutCard(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Category detail list
                    _buildCategoryDetailSection(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Savings tip card
                    _buildSavingsTipCard(),
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
          Text(
            'Finzy',
            style: FinzyTheme.headlineLg.copyWith(color: FinzyTheme.primary),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: FinzyTheme.primary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Period Filter
  // ---------------------------------------------------------------------------

  Widget _buildPeriodFilter() {
    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
        border: Border.all(color: FinzyTheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingXs),
      child: Row(
        children: List.generate(_periods.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriodIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? FinzyTheme.surfaceContainerLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
                  boxShadow: isSelected ? FinzyTheme.cardShadow : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _periods[index],
                  style: FinzyTheme.bodyMd.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? FinzyTheme.onSurface
                        : FinzyTheme.onSurfaceVariant,
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
  // Donut Chart Card
  // ---------------------------------------------------------------------------

  Widget _buildDonutCard() {
    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      child: Column(
        children: [
          // Donut chart
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: _DonutChartPainter(categories: _mockCategories),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tổng chi',
                      style: FinzyTheme.labelMd.copyWith(
                        color: FinzyTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '8.450k',
                      style: FinzyTheme.headlineLg.copyWith(
                        color: FinzyTheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),

          // Legend — 2 columns
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLegendItem(_mockCategories[0])),
            Expanded(child: _buildLegendItem(_mockCategories[1])),
          ],
        ),
        const SizedBox(height: FinzyTheme.spacingSm),
        Row(
          children: [
            Expanded(child: _buildLegendItem(_mockCategories[2])),
            Expanded(child: _buildLegendItem(_mockCategories[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(_CategoryData cat) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: cat.chartColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: FinzyTheme.spacingXs),
        Text(
          '${cat.name} (${cat.percent}%)',
          style: FinzyTheme.labelMd.copyWith(color: FinzyTheme.onSurface),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Category Detail Section
  // ---------------------------------------------------------------------------

  Widget _buildCategoryDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chi tiết hạng mục',
          style: FinzyTheme.headlineMd.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: FinzyTheme.spacingMd),
        FinzyCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(_mockCategories.length, (i) {
              final cat = _mockCategories[i];
              final isLast = i == _mockCategories.length - 1;
              return Column(
                children: [
                  _buildCategoryRow(cat),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: FinzyTheme.spacingMd,
                      endIndent: FinzyTheme.spacingMd,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(_CategoryData cat) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      child: Padding(
        padding: const EdgeInsets.all(FinzyTheme.spacingMd),
        child: Column(
          children: [
            Row(
              children: [
                // Icon bubble
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

                // Name + sub
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.name,
                        style: FinzyTheme.bodyLg
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cat.percent}% tổng chi',
                        style: FinzyTheme.labelMd,
                      ),
                    ],
                  ),
                ),

                // Amount + chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatVnd(cat.amount),
                      style: FinzyTheme.bodyLg.copyWith(
                        fontWeight: FontWeight.w700,
                        color: FinzyTheme.onSurface,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: FinzyTheme.onSurfaceVariant,
                    ),
                  ],
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
                    borderRadius:
                        BorderRadius.circular(FinzyTheme.radiusFull),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: cat.percent / 100,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: cat.chartColor,
                      borderRadius:
                          BorderRadius.circular(FinzyTheme.radiusFull),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Savings Tip Card
  // ---------------------------------------------------------------------------

  Widget _buildSavingsTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      decoration: BoxDecoration(
        color: FinzyTheme.primary,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: FinzyTheme.primaryContainer,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: FinzyTheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mẹo tiết kiệm',
                  style: FinzyTheme.bodyLg.copyWith(
                    color: FinzyTheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: FinzyTheme.spacingXs),
                RichText(
                  text: TextSpan(
                    style: FinzyTheme.bodyMd.copyWith(
                      color: FinzyTheme.onPrimary.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                          text:
                              'Bạn đã chi nhiều hơn 15% cho '),
                      TextSpan(
                        text: 'Ăn uống',
                        style: FinzyTheme.bodyMd.copyWith(
                          color: FinzyTheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' so với tháng trước. Hãy thử nấu ăn tại nhà nhiều hơn nhé!',
                      ),
                    ],
                  ),
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
    final str = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '${str}đ';
  }
}

// ---------------------------------------------------------------------------
// Donut Chart Painter
// ---------------------------------------------------------------------------

class _DonutChartPainter extends CustomPainter {
  final List<_CategoryData> categories;

  const _DonutChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    const strokeWidth = 36.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    double startAngle = -pi / 2; // start from top

    for (final cat in categories) {
      final sweepAngle = 2 * pi * (cat.percent / 100);
      final paint = Paint()
        ..color = cat.chartColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle - 0.04, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => false;
}
