import 'package:flutter/material.dart';

// TODO: Import file FinzyTheme của bạn vào đây
// Ví dụ: import 'package:finzy/theme/finzy_theme.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  // Trạng thái cho Filter chips
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["Tất cả", "Thu nhập", "Chi tiêu", "Chuyển khoản"];

  // Mock Data: Danh sách giao dịch được nhóm theo ngày
  final List<Map<String, dynamic>> _groupedTransactions = [
    {
      "date": "Hôm nay",
      "transactions": [
        {
          "title": "Cửa hàng tiện lợi",
          "category": "Ăn uống",
          "time": "14:30",
          "amount": "- 150.000 ₫",
          "isIncome": false,
          "icon": Icons.shopping_bag_rounded,
          "color": Colors.orange,
        },
        {
          "title": "Thanh toán Netflix",
          "category": "Giải trí",
          "time": "08:15",
          "amount": "- 260.000 ₫",
          "isIncome": false,
          "icon": Icons.movie_rounded,
          "color": Colors.redAccent,
        },
      ]
    },
    {
      "date": "Hôm qua",
      "transactions": [
        {
          "title": "Nhận lương tháng 5",
          "category": "Lương",
          "time": "09:00",
          "amount": "+ 25.000.000 ₫",
          "isIncome": true,
          "icon": Icons.account_balance_rounded,
          "color": Colors.green,
        },
        {
          "title": "GrabBike",
          "category": "Di chuyển",
          "time": "07:30",
          "amount": "- 45.000 ₫",
          "isIncome": false,
          "icon": Icons.directions_bike_rounded,
          "color": Colors.blueAccent,
        },
      ]
    },
    {
      "date": "20 Tháng 5, 2026",
      "transactions": [
        {
          "title": "Thanh toán tiền điện",
          "category": "Hóa đơn",
          "time": "18:20",
          "amount": "- 850.000 ₫",
          "isIncome": false,
          "icon": Icons.electric_bolt_rounded,
          "color": Colors.amber,
        },
        {
          "title": "Chuyển tiền cho Mẹ",
          "category": "Chuyển khoản",
          "time": "10:00",
          "amount": "- 2.000.000 ₫",
          "isIncome": false,
          "icon": Icons.send_rounded,
          "color": Colors.blueAccent,
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: FinzyTheme.backgroundColor,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        // backgroundColor: FinzyTheme.backgroundColor,
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        title: const Text(
          "Lịch sử giao dịch",
          // style: FinzyTheme.heading2,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        // Bọc toàn bộ nội dung trong SingleChildScrollView để chống overflow
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildFilters(),
              const SizedBox(height: 24),
              _buildTransactionList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  // color: isSelected ? FinzyTheme.primaryColor : Colors.white,
                  color: isSelected ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    // color: isSelected ? FinzyTheme.primaryColor : FinzyTheme.borderColor,
                    color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    // color: isSelected ? Colors.white : FinzyTheme.textSecondary,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _groupedTransactions.map((group) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Ngày giao dịch
                Text(
                  group["date"],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                // Danh sách các giao dịch trong ngày đó
                ...group["transactions"].map<Widget>((transaction) {
                  return _buildTransactionItem(transaction);
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: transaction["color"].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction["icon"],
                color: transaction["color"],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction["category"],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: CircleAvatar(
                          radius: 2,
                          backgroundColor: Colors.grey.shade400,
                        ),
                      ),
                      Text(
                        transaction["time"],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              transaction["amount"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction["isIncome"] ? Colors.green : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
