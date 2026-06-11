import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Screen 15 — displayed as a bottom-sheet modal overlay on top of the goals list.
/// Can be pushed as a full route or shown via showModalBottomSheet.
class GoalCompleteScreen extends StatelessWidget {
  const GoalCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: _buildModal(context),
      ),
    );
  }

  Widget _buildModal(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusXl),
        boxShadow: FinzyTheme.modalShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Teal hero area
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [FinzyTheme.primary, FinzyTheme.primaryContainer],
              ),
            ),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: FinzyTheme.spacingMd,
                  right: FinzyTheme.spacingMd,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: FinzyTheme.onPrimary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: FinzyTheme.onPrimary, size: 18),
                    ),
                  ),
                ),
                // Celebration icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: FinzyTheme.onPrimary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.savings,
                        color: FinzyTheme.onPrimary, size: 52),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(FinzyTheme.spacingLg),
            child: Column(
              children: [
                // Title
                const Text(
                  '🎉 Bạn đã đạt mục tiêu!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: FinzyTheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FinzyTheme.spacingSm),
                Text(
                  'Chúc mừng bạn! Heo đất của bạn đã đầy. Hãy tận hưởng thành quả sau những ngày kiên trì nhé!',
                  style: FinzyTheme.bodyMd.copyWith(
                      color: FinzyTheme.onSurfaceVariant, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FinzyTheme.spacingLg),

                // Goal summary card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: FinzyTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'MỤC TIÊU CỦA BẠN',
                        style: FinzyTheme.labelMd.copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: FinzyTheme.spacingXs),
                      Text(
                        'Mua MacBook Pro M3',
                        style: FinzyTheme.headlineSm
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Text(
                            'Tổng\ntiền\nđạt\nđược',
                            style: FinzyTheme.labelMd,
                          ),
                          const SizedBox(width: FinzyTheme.spacingMd),
                          Text(
                            '50.000.000đ',
                            style: FinzyTheme.displayCurrency.copyWith(
                              color: FinzyTheme.secondary,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FinzyTheme.spacingLg),

                // Buttons
                PrimaryButton(
                  label: 'Tất toán & rút tiền',
                  icon: Icons.arrow_forward,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: FinzyTheme.spacingSm),
                SecondaryButton(
                  label: 'Tiếp tục tích lũy',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to show this as a dialog/overlay on any screen.
Future<void> showGoalCompleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const GoalCompleteScreen(),
  );
}
