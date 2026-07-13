import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  final String goalId;
  final String goalName;
  final double currentAmount;

  const WithdrawMoneyScreen({
    super.key,
    required this.goalId,
    required this.goalName,
    required this.currentAmount,
  });

  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  String _amount = '0';
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else if (key == '000') {
        if (_amount == '0') return;
        _amount = _amount + '000';
      } else {
        if (_amount == '0') {
          _amount = key;
        } else {
          _amount = _amount + key;
        }
      }
    });
  }

  void _addQuick(int value) {
    setState(() {
      final current = int.tryParse(_amount) ?? 0;
      _amount = (current + value).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount =
        int.tryParse(_amount)?.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') ??
            _amount;

    return Scaffold(
      backgroundColor: FinzyTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FinzyTheme.spacingSm, vertical: FinzyTheme.spacingXs),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Rút tiền từ heo',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd
                          .copyWith(color: FinzyTheme.error, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                child: Column(
                  children: [
                    // Goal info card
                    FinzyCard(
                      padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: FinzyTheme.errorContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.account_balance_wallet,
                                    color: FinzyTheme.error, size: 26),
                              ),
                              const SizedBox(width: FinzyTheme.spacingMd),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mục tiêu của bạn',
                                      style: FinzyTheme.labelMd),
                                  Text(widget.goalName,
                                      style: FinzyTheme.bodyLg.copyWith(
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Hiện có', style: FinzyTheme.bodyMd),
                              Text(
                                '${widget.currentAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ',
                                style: FinzyTheme.bodyLg.copyWith(
                                    color: FinzyTheme.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Amount display
                    Text('SỐ TIỀN MUỐN RÚT',
                        style: FinzyTheme.labelMd.copyWith(letterSpacing: 1)),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          displayAmount,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: FinzyTheme.error,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('đ',
                            style: FinzyTheme.headlineLg
                                .copyWith(color: FinzyTheme.error)),
                      ],
                    ),
                    Container(
                      height: 2,
                      width: 180,
                      color: FinzyTheme.error,
                      margin: const EdgeInsets.only(top: 4),
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),

                    // Quick-add chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _QuickChip(label: '+50k', onTap: () => _addQuick(50000)),
                        const SizedBox(width: FinzyTheme.spacingSm),
                        _QuickChip(label: '+100k', onTap: () => _addQuick(100000)),
                        const SizedBox(width: FinzyTheme.spacingSm),
                        _QuickChip(label: '+200k', onTap: () => _addQuick(200000)),
                        const SizedBox(width: FinzyTheme.spacingSm),
                        _QuickChip(label: 'Tối đa', onTap: () => setState(() {
                          _amount = widget.currentAmount.toInt().toString();
                        })),
                      ],
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Number pad
                    _buildNumberPad(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Lời nhắn / Ghi chú
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('GHI CHÚ (KHÔNG BẮT BUỘC)',
                          style: FinzyTheme.labelMd),
                    ),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    CustomTextField(
                      controller: _noteController,
                      hint: 'Ví dụ: Rút tiền mua sắm...',
                      prefixIcon: const Icon(Icons.edit_note,
                          color: FinzyTheme.onSurfaceVariant, size: 20),
                    ),
                    const SizedBox(height: FinzyTheme.spacingMd),
                  ],
                ),
              ),
            ),

            // CTA + note
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  FinzyTheme.spacingMd, 0, FinzyTheme.spacingMd, FinzyTheme.spacingMd),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: FinzyTheme.buttonMinHeight,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        final amount = double.tryParse(_amount) ?? 0;
                        if (amount <= 0) return;
                        if (amount > widget.currentAmount) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Số dư không đủ để rút số tiền này')),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);

                        try {
                          final note = _noteController.text.trim().isEmpty 
                              ? 'Rút tiền từ heo' 
                              : _noteController.text.trim();
                          final success = await ApiService.withdrawMoney(widget.goalId, amount, note);
                          if (success) {
                            NotificationService.notifyNewTransaction();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rút tiền thành công!')),
                              );
                              Navigator.of(context).pop();
                            }
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rút tiền thất bại')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: $e')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FinzyTheme.error,
                        foregroundColor: FinzyTheme.onError,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                        ),
                      ),
                      icon: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: FinzyTheme.onError, strokeWidth: 2))
                          : const Icon(Icons.remove_circle_outline, size: 20),
                      label: Text(_isLoading ? 'Đang xử lý...' : 'Xác nhận rút tiền',
                          style: FinzyTheme.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: FinzyTheme.spacingSm),
                  Text(
                    'Tiền sẽ được cộng trực tiếp vào Ví Finzy',
                    style: FinzyTheme.labelMd
                        .copyWith(color: FinzyTheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['000', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: GestureDetector(
                onTap: () => _onKey(key),
                child: Container(
                  height: 62,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: key == '⌫'
                        ? FinzyTheme.errorContainer
                        : FinzyTheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                    boxShadow: FinzyTheme.cardShadow,
                  ),
                  child: Center(
                    child: key == '⌫'
                        ? Icon(Icons.backspace_outlined,
                            color: FinzyTheme.error, size: 22)
                        : Text(
                            key,
                            style: FinzyTheme.headlineSm.copyWith(
                                fontWeight: FontWeight.w600,
                                color: FinzyTheme.onSurface),
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: FinzyTheme.errorContainer,
          borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
        ),
        child: Text(
          label,
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
