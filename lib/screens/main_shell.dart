import 'package:flutter/material.dart';
import 'package:finzy/theme/app_theme.dart';
import 'package:finzy/screens/dashboard_screen.dart';
import 'package:finzy/screens/transaction_list_screen.dart';
import 'package:finzy/screens/statistics_overview_screen.dart';
import 'package:finzy/screens/savings_goals_screen.dart';
import 'package:finzy/screens/profile_screen.dart';

/// Root shell — holds the 5-tab BottomNavigationBar and swaps child screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  // Keep screens alive between tab switches
  static const List<Widget> _screens = [
    DashboardScreen(),
    TransactionListScreen(),
    StatisticsOverviewScreen(),
    SavingsGoalsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: FinzyTheme.bottomNavBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Giao dịch',
                index: 1,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: 'Thống kê',
                index: 2,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              _NavItem(
                icon: Icons.savings_outlined,
                activeIcon: Icons.savings,
                label: 'Heo',
                index: 3,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Tôi',
                index: 4,
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? FinzyTheme.primary : FinzyTheme.outline,
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: FinzyTheme.labelMd.copyWith(
                color: isActive ? FinzyTheme.primary : FinzyTheme.outline,
                letterSpacing: 0,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
