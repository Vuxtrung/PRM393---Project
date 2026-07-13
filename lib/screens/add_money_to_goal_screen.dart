import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class AddMoneyToGoalScreen extends StatefulWidget {
  final String goalId;
  final String goalName;
  final double currentAmount;

  const AddMoneyToGoalScreen({
    super.key,
    required this.goalId,
    required this.goalName,
    required this.currentAmount,
  });

  @override
  State<AddMoneyToGoalScreen> createState() => _AddMoneyToGoalScreenState();
}

class _AddMoneyToGoalScreenState extends State<AddMoneyToGoalScreen> {
  String _amount = '0';
  final TextEditingController _noteController = TextEditingController();

  bool _isLoadingLastTransaction = true;
  Map<String, dynamic>? _lastTransaction;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLastTransaction();
  }

  Future<void> _fetchLastTransaction() async {
    try {
      final data = await ApiService.getGoalById(widget.goalId);
      final List transactions = data['transactions'] ?? [];
      
      Map<String, dynamic>? lastDeposit;
      for (var t in transactions) {
        if ((t['amount'] as num) > 0) {
          lastDeposit = t;
          break; // Assuming the first one is the newest. If not, this gets the oldest. Let's just use the last one in the list to be safe if it's oldest first.
        }
      }
      
      // Usually APIs return newest first or oldest first. Let's reverse find if needed.
      // Actually, let's just find the latest by date if we want to be robust.
      if (transactions.isNotEmpty) {
        final deposits = transactions.where((t) => (t['amount'] as num) > 0).toList();
        if (deposits.isNotEmpty) {
           deposits.sort((a, b) {
             final dateA = DateTime.parse(a['transactionDate'] ?? a['createdAt']);
             final dateB = DateTime.parse(b['transactionDate'] ?? b['createdAt']);
             return dateB.compareTo(dateA); // Newest first
           });
           lastDeposit = deposits.first;
        }
      }

      if (mounted) {
        setState(() {
          _lastTransaction = lastDeposit;
          _isLoadingLastTransaction = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLastTransaction = false);
      }
    }
  }

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
                      'Nạp vào heo',
                      textAlign: TextAlign.center,
                      style: FinzyTheme.headlineMd
                          .copyWith(color: FinzyTheme.primary, fontWeight: FontWeight.w700),
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
                                  color: FinzyTheme.secondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone_iphone,
                                    color: Colors.white, size: 26),
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
                    Text('SỐ TIỀN MUỐN NẠP',
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
                            color: FinzyTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('đ',
                            style: FinzyTheme.headlineLg
                                .copyWith(color: FinzyTheme.primary)),
                      ],
                    ),
                    Container(
                      height: 2,
                      width: 180,
                      color: FinzyTheme.primary,
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
                        _QuickChip(label: '+500k', onTap: () => _addQuick(500000)),
                      ],
                    ),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Number pad
                    _buildNumberPad(),
                    const SizedBox(height: FinzyTheme.spacingLg),

                    // Lặp lại giao dịch
                    if (!_isLoadingLastTransaction && _lastTransaction != null) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _amount = (_lastTransaction!['amount'] as num).toInt().toString();
                            _noteController.text = _lastTransaction!['note'] ?? '';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã điền thông tin giao dịch trước đó')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(FinzyTheme.spacingMd),
                          decoration: BoxDecoration(
                            color: FinzyTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(FinzyTheme.radiusMd),
                            border: Border.all(color: FinzyTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: FinzyTheme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.history, color: FinzyTheme.primary, size: 20),
                              ),
                              const SizedBox(width: FinzyTheme.spacingMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lặp lại giao dịch trước đó',
                                        style: FinzyTheme.labelMd.copyWith(
                                            color: FinzyTheme.primary,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${(_lastTransaction!['amount'] as num).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ${_lastTransaction!['note'] != null && _lastTransaction!['note'].toString().isNotEmpty ? ' - ${_lastTransaction!['note']}' : ''}',
                                      style: FinzyTheme.bodyMd,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: FinzyTheme.spacingLg),
                    ],

                    // Lời nhắn / Ghi chú
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('GHI CHÚ (KHÔNG BẮT BUỘC)',
                          style: FinzyTheme.labelMd),
                    ),
                    const SizedBox(height: FinzyTheme.spacingSm),
                    CustomTextField(
                      controller: _noteController,
                      hint: 'Ví dụ: Tiền thưởng tháng 10...',
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
                  PrimaryButton(
                    label: _isLoading ? 'Đang xử lý...' : 'Nạp vào heo',
                    icon: _isLoading ? null : Icons.add,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : () async {
                      final amount = double.tryParse(_amount) ?? 0;
                      if (amount <= 0) return;

                      setState(() => _isLoading = true);

                      try {
                        final note = _noteController.text.trim().isEmpty 
                            ? 'Nạp tiền vào heo' 
                            : _noteController.text.trim();
                        final success = await ApiService.addMoney(widget.goalId, amount, note);
                        if (success) {
                          NotificationService.notifyNewTransaction();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Nạp tiền thành công!')),
                            );
                            Navigator.of(context).pop();
                          }
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nạp tiền thất bại')),
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
                  ),
                  const SizedBox(height: FinzyTheme.spacingSm),
                  Text(
                    'Giao dịch sẽ được trừ trực tiếp vào Ví Finzy',
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
          color: FinzyTheme.primaryFixed,
          borderRadius: BorderRadius.circular(FinzyTheme.radiusFull),
        ),
        child: Text(
          label,
          style: FinzyTheme.bodyMd.copyWith(
            color: FinzyTheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
