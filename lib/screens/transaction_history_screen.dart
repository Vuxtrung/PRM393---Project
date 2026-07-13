import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final String goalName;
  final List<dynamic> transactions;

  const TransactionHistoryScreen({
    super.key,
    required this.goalName,
    required this.transactions,
  });

  String _fmt(double amount) {
    final s = amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '${s}đ';
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
          'Lịch sử giao dịch',
          style: FinzyTheme.headlineMd.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FinzyTheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: FinzyTheme.surfaceContainerHigh,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: transactions.isEmpty
            ? const Center(child: Text('Chưa có giao dịch nào'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: FinzyTheme.spacingMd),
                itemCount: transactions.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: FinzyTheme.spacingLg + 44 + FinzyTheme.spacingMd,
                  endIndent: FinzyTheme.spacingMd,
                ),
                itemBuilder: (context, index) {
                  final trx = transactions[index];
                  final amountNum = (trx['amount'] as num).toDouble();
                  final date = DateTime.parse(trx['transactionDate'] ?? trx['createdAt']).toLocal();
                  final isPositive = amountNum >= 0;
                  final displayAmountStr = _fmt(amountNum.abs());

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: FinzyTheme.spacingMd,
                        vertical: FinzyTheme.spacingSm),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isPositive
                                ? FinzyTheme.secondaryFixed
                                : FinzyTheme.errorContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPositive ? Icons.savings : Icons.account_balance_wallet,
                            color: isPositive
                                ? FinzyTheme.onSecondaryFixed
                                : FinzyTheme.error,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: FinzyTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trx['note'] ?? 'Giao dịch',
                                  style: FinzyTheme.bodyLg
                                      .copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(
                                  '${date.hour}:${date.minute.toString().padLeft(2, '0')} • ${date.day}/${date.month}/${date.year}',
                                  style: FinzyTheme.labelMd),
                            ],
                          ),
                        ),
                        Text(
                          isPositive
                              ? '+$displayAmountStr'
                              : '-$displayAmountStr',
                          style: FinzyTheme.bodyLg.copyWith(
                              color:
                                  isPositive ? FinzyTheme.income : FinzyTheme.error,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
