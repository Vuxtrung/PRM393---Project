import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Mock state data
  bool isExpense = true;
  String selectedCategory = "Ăn uống";
  String selectedWallet = "Ví tiền mặt";
  
  // Controller for amount, allowing realistic input simulation
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      appBar: AppBar(
        title: Text("Thêm giao dịch", style: FinzyTheme.headlineMd),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(FinzyTheme.spacingMd), // 16px padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Transaction Type Toggle (Expense / Income)
              _buildTypeToggle(),
              const SizedBox(height: FinzyTheme.spacingLg), // 24px margin

              // 2. Amount Input
              Text("SỐ TIỀN", style: FinzyTheme.labelMd),
              const SizedBox(height: FinzyTheme.spacingSm),
              CustomTextField(
                controller: _amountController,
                hint: "0",
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FinzyTheme.spacingMd),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "₫",
                        style: FinzyTheme.headlineLg.copyWith(
                          color: isExpense ? FinzyTheme.expense : FinzyTheme.income,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FinzyTheme.spacingLg),

              // 3. Category Selector
              Text("DANH MỤC", style: FinzyTheme.labelMd),
              const SizedBox(height: FinzyTheme.spacingSm),
              _buildSelectorField(
                icon: Icons.restaurant,
                iconColor: FinzyTheme.secondaryContainer,
                label: selectedCategory,
                onTap: () {
                  // Show category bottom sheet (Mock)
                },
              ),
              const SizedBox(height: FinzyTheme.spacingLg),

              // 4. Note Input
              Text("GHI CHÚ", style: FinzyTheme.labelMd),
              const SizedBox(height: FinzyTheme.spacingSm),
              const CustomTextField(
                hint: "Thêm ghi chú...",
                maxLines: 3,
              ),
              const SizedBox(height: FinzyTheme.spacingLg),

              // 5. Date Selector
              Text("NGÀY", style: FinzyTheme.labelMd),
              const SizedBox(height: FinzyTheme.spacingSm),
              _buildSelectorField(
                icon: Icons.calendar_today,
                iconColor: FinzyTheme.primary,
                label: "Hôm nay, 10/06/2026",
                onTap: () {
                  // Show date picker (Mock)
                },
              ),
              const SizedBox(height: FinzyTheme.spacingLg),

              // 6. Wallet / Account Selector
              Text("TÀI KHOẢN", style: FinzyTheme.labelMd),
              const SizedBox(height: FinzyTheme.spacingSm),
              _buildSelectorField(
                icon: Icons.account_balance_wallet,
                iconColor: FinzyTheme.tertiary,
                label: selectedWallet,
                onTap: () {
                  // Show wallet bottom sheet (Mock)
                },
              ),
              
              const SizedBox(height: FinzyTheme.spacingXl), // 32px
              
              // 7. Save Button
              PrimaryButton(
                label: "Lưu giao dịch",
                onPressed: () {
                  // Save logic (Mock)
                },
              ),
              const SizedBox(height: FinzyTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a pill-shaped toggle for Income vs Expense
  Widget _buildTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: FinzyTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
      ),
      padding: const EdgeInsets.all(FinzyTheme.spacingXs),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpense = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isExpense ? FinzyTheme.surfaceContainerLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
                  boxShadow: isExpense ? FinzyTheme.cardShadow : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Chi phí",
                  style: FinzyTheme.bodyLg.copyWith(
                    fontWeight: isExpense ? FontWeight.w600 : FontWeight.w400,
                    color: isExpense ? FinzyTheme.expense : FinzyTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpense = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isExpense ? FinzyTheme.surfaceContainerLowest : Colors.transparent,
                  borderRadius: BorderRadius.circular(FinzyTheme.radiusSm),
                  boxShadow: !isExpense ? FinzyTheme.cardShadow : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Thu nhập",
                  style: FinzyTheme.bodyLg.copyWith(
                    fontWeight: !isExpense ? FontWeight.w600 : FontWeight.w400,
                    color: !isExpense ? FinzyTheme.income : FinzyTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a clickable field mimicking a dropdown or picker trigger
  Widget _buildSelectorField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FinzyTheme.spacingMd,
          vertical: FinzyTheme.spacingMd,
        ),
        decoration: BoxDecoration(
          color: FinzyTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
          border: Border.all(color: FinzyTheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: FinzyTheme.iconSize),
            ),
            const SizedBox(width: FinzyTheme.spacingMd),
            Expanded(
              child: Text(label, style: FinzyTheme.bodyLg),
            ),
            const Icon(Icons.chevron_right, color: FinzyTheme.outline),
          ],
        ),
      ),
    );
  }
}
