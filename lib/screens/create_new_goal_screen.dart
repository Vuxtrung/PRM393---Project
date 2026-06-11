import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'savings_goals_screen.dart';

class CreateNewGoalScreen extends StatefulWidget {
  const CreateNewGoalScreen({super.key});

  @override
  State<CreateNewGoalScreen> createState() => _CreateNewGoalScreenState();
}

class _CreateNewGoalScreenState extends State<CreateNewGoalScreen> {
  int _selectedIconIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  final List<IconData> _icons = [
    Icons.savings,
    Icons.flight_takeoff,
    Icons.directions_car,
    Icons.home_outlined,
    Icons.laptop_mac,
    Icons.favorite_outline,
    Icons.celebration,
    Icons.school_outlined,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.shopping_bag_outlined,
    Icons.more_horiz,
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
                      'Tạo Mục Tiêu Mới',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline,
                        color: FinzyTheme.onSurfaceVariant),
                    onPressed: () {},
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

                    // Form card
                    FinzyCard(
                      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Goal name
                          Text('TÊN MỤC TIÊU', style: FinzyTheme.labelMd),
                          const SizedBox(height: FinzyTheme.spacingSm),
                          CustomTextField(
                            controller: _nameController,
                            hint: 'Ví dụ: Mua iPhone 15, Du lịch Nhật Bản...',
                            prefixIcon: const Icon(Icons.edit_outlined,
                                color: FinzyTheme.onSurfaceVariant, size: 20),
                          ),
                          const SizedBox(height: FinzyTheme.spacingMd),

                          // Amount
                          Text('SỐ TIỀN CẦN TIẾT KIỆM',
                              style: FinzyTheme.labelMd),
                          const SizedBox(height: FinzyTheme.spacingSm),
                          CustomTextField(
                            controller: _amountController,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Text('đ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: FinzyTheme.primary)),
                            ),
                            suffixIcon: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Text('VND',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: FinzyTheme.onSurfaceVariant)),
                            ),
                          ),
                          const SizedBox(height: FinzyTheme.spacingMd),

                          // Date
                          Text('NGÀY KẾT THÚC DỰ KIẾN',
                              style: FinzyTheme.labelMd),
                          const SizedBox(height: FinzyTheme.spacingSm),
                          CustomTextField(
                            controller: _dateController,
                            hint: 'mm/dd/yyyy',
                            keyboardType: TextInputType.datetime,
                            prefixIcon: const Icon(Icons.calendar_today_outlined,
                                color: FinzyTheme.onSurfaceVariant, size: 20),
                            suffixIcon: const Icon(Icons.calendar_month,
                                color: FinzyTheme.onSurfaceVariant, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Icon picker
                    Text('Chọn biểu tượng',
                        style: FinzyTheme.headlineSm
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: FinzyTheme.spacingMd),
                    _buildIconGrid(),
                    const SizedBox(height: FinzyTheme.spacingXl),

                    // CTA
                    PrimaryButton(
                      label: 'Tạo mục tiêu',
                      icon: Icons.savings,
                      onPressed: () {
                        final name = _nameController.text.trim();
                        final amountText = _amountController.text.trim();
                        final date = _dateController.text.trim();

                        if (name.isEmpty || amountText.isEmpty || date.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
                          );
                          return;
                        }

                        final target = int.tryParse(amountText) ?? 0;
                        if (target <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Số tiền không hợp lệ')),
                          );
                          return;
                        }

                        final newGoal = GoalItem(
                          name: name,
                          icon: _icons[_selectedIconIndex],
                          iconColor: FinzyTheme.onPrimary,
                          iconBg: FinzyTheme.primary,
                          deadline: date,
                          timeLeft: 'Mới tạo',
                          urgency: GoalUrgency.normal,
                          current: 0,
                          target: target,
                          percent: 0,
                        );

                        Navigator.of(context).pop(newGoal);
                      },
                    ),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    Center(
                      child: Text(
                        'Bằng việc tạo mục tiêu, bạn đồng ý với Điều khoản tiết kiệm của Finzy.',
                        style: FinzyTheme.labelMd
                            .copyWith(color: FinzyTheme.onSurfaceVariant),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinzyTheme.spacingLg),
      decoration: BoxDecoration(
        color: FinzyTheme.primaryFixed,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: FinzyTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.savings, color: FinzyTheme.onPrimary, size: 36),
          ),
          const SizedBox(height: FinzyTheme.spacingMd),
          Text(
            'Biến ước mơ thành hiện thực',
            style: FinzyTheme.headlineSm.copyWith(
              color: FinzyTheme.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinzyTheme.spacingXs),
          Text(
            'Lập kế hoạch tiết kiệm ngay hôm nay.',
            style: FinzyTheme.bodyMd
                .copyWith(color: FinzyTheme.onPrimaryFixedVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIconGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: FinzyTheme.spacingSm,
        crossAxisSpacing: FinzyTheme.spacingSm,
        childAspectRatio: 1,
      ),
      itemCount: _icons.length,
      itemBuilder: (_, i) {
        final isSelected = i == _selectedIconIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedIconIndex = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? FinzyTheme.primaryFixed : FinzyTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
              border: Border.all(
                color: isSelected ? FinzyTheme.primary : FinzyTheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: FinzyTheme.cardShadow,
            ),
            child: Icon(
              _icons[i],
              color: isSelected ? FinzyTheme.primary : FinzyTheme.onSurfaceVariant,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
