import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real order data
    final orders = [
      {'id': 'ORD001', 'status': 'กำลังจัดส่ง', 'date': '2025-09-01'},
      {'id': 'ORD002', 'status': 'สำเร็จ', 'date': '2025-08-25'},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('ປະຫວັດການສັ່ງຊື້', style: GoogleFonts.notoSansLao()),
      ),
      body: ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(
              'Order #${order['id']}',
              style: GoogleFonts.notoSansLao(),
            ),
            subtitle: Text(
              'Status: ${order['status']}\nDate: ${order['date']}',
              style: GoogleFonts.notoSansLao(fontSize: 13),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          );
        },
      ),
    );
  }
}
