import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _CategoryItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String name;
  final String description;

  const _CategoryItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.name,
    required this.description,
  });
}

const List<_CategoryItem> _expenseCategories = [
  _CategoryItem(
    icon: Icons.restaurant,
    iconColor: Color(0xFFF97316),
    iconBg: Color(0xFFFFF0E6),
    name: 'Ăn uống',
    description: 'Chi tiêu hàng ngày',
  ),
  _CategoryItem(
    icon: Icons.directions_car,
    iconColor: Color(0xFF3B82F6),
    iconBg: Color(0xFFEFF6FF),
    name: 'Di chuyển',
    description: 'Grab, xăng xe, bảo dưỡng',
  ),
  _CategoryItem(
    icon: Icons.shopping_bag,
    iconColor: Color(0xFFEC4899),
    iconBg: Color(0xFFFDF2F8),
    name: 'Mua sắm',
    description: 'Quần áo, phụ kiện',
  ),
  _CategoryItem(
    icon: Icons.tv,
    iconColor: Color(0xFF8B5CF6),
    iconBg: Color(0xFFF5F3FF),
    name: 'Giải trí',
    description: 'Netflix, xem phim, du lịch',
  ),
  _CategoryItem(
    icon: Icons.shield_outlined,
    iconColor: Color(0xFF22C55E),
    iconBg: Color(0xFFF0FDF4),
    name: 'Sức khỏe',
    description: 'Gym, bệnh viện, thuốc',
  ),
];

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  int _selectedTab = 1; // 0: Thu nhập, 1: Chi tiêu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
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
                      'Danh Mục',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd
                          .copyWith(color: FinzyTheme.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: FinzyTheme.primary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: FinzyTheme.inverseSurface,
                        borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
                      ),
                      child: const Icon(Icons.view_agenda_outlined,
                          color: FinzyTheme.inverseOnSurface, size: 18),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
              child: Column(
                children: [
                  // Tab bar
                  _buildTabBar(),
                  const SizedBox(height: FinzyTheme.spacingMd),

                  // Section label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'TẤT CẢ DANH MỤC (${_expenseCategories.length + 7})',
                      style: FinzyTheme.labelMd.copyWith(letterSpacing: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FinzyTheme.spacingSm),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
                child: Column(
                  children: [
                    // First 2 categories
                    ..._expenseCategories.take(2).map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: FinzyTheme.spacingSm),
                          child: _CategoryRow(category: c),
                        )),

                    // Banner ad
                    _buildBanner(),
                    const SizedBox(height: FinzyTheme.spacingSm),

                    // Remaining categories
                    ..._expenseCategories.skip(2).map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: FinzyTheme.spacingSm),
                          child: _CategoryRow(category: c),
                        )),

                    const SizedBox(height: 80), // space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: FinzyTheme.primary,
        foregroundColor: FinzyTheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
        border: Border.all(color: FinzyTheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingXs),
      child: Row(
        children: [
          Expanded(child: _Tab(label: 'Thu nhập', selected: _selectedTab == 0, onTap: () => setState(() => _selectedTab = 0))),
          Expanded(child: _Tab(label: 'Chi tiêu', selected: _selectedTab == 1, onTap: () => setState(() => _selectedTab = 1))),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FinzyTheme.radiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
        ),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1518623489648-a173ef7824f3?w=600',
          ),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Mẹo tiết kiệm',
            style: FinzyTheme.labelMd.copyWith(
              color: FinzyTheme.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Quản lý danh mục thông minh giúp bạn kiểm soát dòng tiền tốt hơn',
            style: FinzyTheme.bodyMd.copyWith(
              color: FinzyTheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final _CategoryItem category;
  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return FinzyCard(
      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.iconColor, size: 24),
          ),
          const SizedBox(width: FinzyTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style:
                        FinzyTheme.bodyLg.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(category.description, style: FinzyTheme.labelMd),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: FinzyTheme.onSurfaceVariant, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: FinzyTheme.onSurfaceVariant, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? FinzyTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: FinzyTheme.bodyMd.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? FinzyTheme.onPrimary : FinzyTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
