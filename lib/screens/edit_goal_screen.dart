import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/goal_model.dart';

class EditGoalScreen extends StatefulWidget {
  final GoalModel goal;

  const EditGoalScreen({super.key, required this.goal});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late int _selectedIconIndex;

  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;

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

  final List<String> _iconNames = [
    'savings',
    'flight_takeoff',
    'directions_car',
    'home_outlined',
    'laptop_mac',
    'favorite_outline',
    'celebration',
    'school_outlined',
    'fitness_center',
    'restaurant',
    'shopping_bag_outlined',
    'more_horiz',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal.name);
    _amountController = TextEditingController(text: widget.goal.targetAmount.toInt().toString());
    
    final d = widget.goal.deadline;
    _dateController = TextEditingController(text: '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}');
    
    _selectedIconIndex = _iconNames.indexOf(widget.goal.icon);
    if (_selectedIconIndex == -1) _selectedIconIndex = 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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
                      'Chỉnh Sửa Mục Tiêu',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 48), // balance
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      label: 'Lưu thay đổi',
                      icon: Icons.save_outlined,
                      onPressed: () async {
                        final name = _nameController.text.trim();
                        final amountText = _amountController.text.trim();
                        final date = _dateController.text.trim();

                        if (name.isEmpty || amountText.isEmpty || date.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
                          );
                          return;
                        }

                        final target = double.tryParse(amountText) ?? 0;
                        if (target <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Số tiền không hợp lệ')),
                          );
                          return;
                        }
                        
                        if (target < widget.goal.currentAmount) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Số tiền mục tiêu không thể nhỏ hơn số dư hiện tại')),
                          );
                          return;
                        }

                        try {
                          final iconName = _iconNames[_selectedIconIndex];
                          final success = await ApiService.editGoal(widget.goal.id, name, target, date, iconName);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chỉnh sửa thành công!')),
                            );
                            Navigator.of(context).pop(true);
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Không thể chỉnh sửa mục tiêu')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: $e')),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),
                    const SizedBox(height: FinzyTheme.spacingLg),
                    
                    // Delete Button
                    SecondaryButton(
                      label: 'Xóa mục tiêu',
                      icon: Icons.delete_outline,
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xóa mục tiêu', style: FinzyTheme.headlineSm),
                            content: const Text('Bạn có chắc chắn muốn xóa mục tiêu này? Hành động này không thể hoàn tác.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Hủy', style: FinzyTheme.bodyMd),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Xóa', style: FinzyTheme.bodyMd.copyWith(color: FinzyTheme.error, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirm == true) {
                          try {
                            final success = await ApiService.deleteGoal(widget.goal.id);
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Xóa mục tiêu thành công!')),
                              );
                              Navigator.of(context).pop('deleted');
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Không thể xóa mục tiêu')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: $e')),
                              );
                            }
                          }
                        }
                      },
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
