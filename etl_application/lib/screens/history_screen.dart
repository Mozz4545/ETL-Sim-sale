import 'package:flutter/material.dart';
import '../core/widgets/tab_menu_widgets.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> orderHistory = [
    {
      'orderId': '1001',
      'date': '2025-08-01',
      'product': 'SIM Card',
      'status': 'Completed',
    },
    {
      'orderId': '1002',
      'date': '2025-08-03',
      'product': 'Top-up',
      'status': 'Pending',
    },
    {
      'orderId': '1003',
      'date': '2025-08-05',
      'product': 'SIM Card',
      'status': 'Cancelled',
    },
  ];

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Column(
        children: [
          // Tab menu widget
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                TabMenuItem(title: 'Dashboard'),
                TabMenuItem(title: 'Order'),
                TabMenuItem(title: 'History'),
                TabMenuItem(title: 'Profile'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(order['orderId']!)),
                    title: Text(order['product']!),
                    subtitle: Text('Date: ${order['date']}'),
                    trailing: Text(order['status']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
