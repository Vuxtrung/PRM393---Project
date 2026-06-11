import 'package:flutter/material.dart';
import 'package:finzy/theme/app_theme.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({super.key});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top row: back + title + share
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: FinzyTheme.primary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Chi tiết giao dịch',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd.copyWith(
                          color: FinzyTheme.primary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: FinzyTheme.onSurface),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Category avatar
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: FinzyTheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant,
                    size: 36, color: FinzyTheme.onSecondaryContainer),
              ),

              const SizedBox(height: 12),

              Text('Ăn uống',
                  style: FinzyTheme.headlineSm
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('HÔM NAY, 12:45 • THỨ HAI',
                  style: FinzyTheme.labelMd
                      .copyWith(color: FinzyTheme.onSurfaceVariant)),

              const SizedBox(height: 16),

              Text(
                '-250.000 đ',
                style: FinzyTheme.headlineLg.copyWith(
                    color: FinzyTheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),

              const SizedBox(height: 20),

              // Details card
              FinzyCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _detailRow(
                      icon: Icons.category_outlined,
                      label: 'Danh mục phụ',
                      value: 'Bữa trưa',
                      valueBold: true,
                    ),
                    const Divider(height: 20),
                    _detailRow(
                      icon: Icons.sticky_note_2_outlined,
                      label: 'Ghi chú',
                      valueWidget: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: FinzyTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"Ăn trưa với bạn bè"',
                          style: FinzyTheme.bodyMd
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    const Divider(height: 20),
                    _detailRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Ví tiền',
                      value: 'Ví chính',
                      valueBold: true,
                      trailing: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: FinzyTheme.primary,
                              shape: BoxShape.circle)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Invoice card
              FinzyCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.image_outlined,
                          color: FinzyTheme.onSurface),
                      const SizedBox(width: 8),
                      Text('Ảnh hóa đơn',
                          style: FinzyTheme.headlineSm
                              .copyWith(fontWeight: FontWeight.w600))
                    ]),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: FinzyTheme.outlineVariant, width: 2),
                        color: FinzyTheme.surfaceContainerLow,
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined,
                            size: 48, color: FinzyTheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      // Bottom buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: FinzyTheme.background,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FinzyTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.edit, size: 20),
                label: Text('Chỉnh sửa',
                    style: FinzyTheme.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: FinzyTheme.onPrimary)),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FinzyTheme.errorContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                icon:
                    const Icon(Icons.delete_outline, color: FinzyTheme.error),
                label: Text('Xóa',
                    style: FinzyTheme.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: FinzyTheme.error)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    String? value,
    bool valueBold = false,
    Widget? valueWidget,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: FinzyTheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: FinzyTheme.labelMd
                      .copyWith(color: FinzyTheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              if (valueWidget != null)
                valueWidget
              else
                Text(
                  value ?? '',
                  style: FinzyTheme.bodyMd.copyWith(
                      fontWeight:
                          valueBold ? FontWeight.w600 : FontWeight.w400),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing,
        ]
      ],
    );
  }
}
