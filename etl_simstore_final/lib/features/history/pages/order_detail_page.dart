import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth.dart';
import '../../home/controllers/custom_navbar_logout.dart';
import '../../../core/models/order_model.dart';

class OrderDetailPage extends ConsumerWidget {
  final Order? order;

  const OrderDetailPage({super.key, this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ตั้งค่า provider reference สำหรับ session management
    SessionManager.setProviderRef(ref);

    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderHeader(context),
            _buildOrderDetails(context),
            _buildOrderItems(context),
            _buildOrderSummary(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 22, 53, 134),
            Colors.blue.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ລາຍລະອຽດຄຳສັ່ງຊື້',
                      style: GoogleFonts.notoSansLaoLooped(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ຄຳສັ່ງຊື້ເລກທີ: ${order?.id ?? "ORD-001"}',
                      style: GoogleFonts.notoSansLaoLooped(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final status = order?.status ?? OrderStatus.pending;
    Color chipColor;

    switch (status) {
      case OrderStatus.delivered:
        chipColor = Colors.green;
        break;
      case OrderStatus.confirmed:
        chipColor = Colors.blue;
        break;
      case OrderStatus.processing:
        chipColor = Colors.orange;
        break;
      case OrderStatus.shipped:
        chipColor = Colors.purple;
        break;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.displayName,
        style: GoogleFonts.notoSansLaoLooped(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ຂໍ້ມູນຄຳສັ່ງຊື້',
                style: GoogleFonts.notoSansLaoLooped(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('ເລກທີຄຳສັ່ງ:', order?.id ?? 'ORD-001'),
              _buildDetailRow('ປະເພດ:', order?.type.displayName ?? 'ຊິມກາດ'),
              _buildDetailRow(
                'ອີເມວລູກຄ້າ:',
                order?.userEmail ?? 'customer@example.com',
              ),
              _buildDetailRow('ເບີໂທ:', order?.phoneNumber ?? '02023655890'),
              _buildDetailRow(
                'ວັນທີສັ່ງ:',
                _formatDate(order?.createdAt ?? DateTime.now()),
              ),
              if (order?.notes != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('ໝາຍເຫດ:', order!.notes!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.notoSansLaoLooped(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoSansLaoLooped(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    final items =
        order?.items ??
        [
          const OrderItem(
            id: '1',
            productId: 'sim-001',
            productName: 'ຊິມກາດເປີຍ່າຈ່າຍ',
            quantity: 1,
            unitPrice: 50000,
            totalPrice: 50000,
            description: 'ເບີໂທ: 02023655890',
          ),
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ລາຍການສິນຄ້າ',
                style: GoogleFonts.notoSansLaoLooped(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...items.map((item) => _buildOrderItem(item)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.notoSansLaoLooped(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: GoogleFonts.notoSansLaoLooped(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ຈຳນວນ: ${item.quantity}',
                style: GoogleFonts.notoSansLaoLooped(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatCurrency(item.totalPrice)} ກີບ',
                style: GoogleFonts.notoSansLaoLooped(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final subtotal = order?.subtotal ?? 50000;
    final tax = order?.tax ?? 0;
    final shipping = order?.shipping ?? 0;
    final total = order?.totalAmount ?? 50000;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ສະຫຼຸບຄຳສັ່ງຊື້',
                style: GoogleFonts.notoSansLaoLooped(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('ລາຄາລວມ:', _formatCurrency(subtotal)),
              if (tax > 0) _buildSummaryRow('ພາສີ:', _formatCurrency(tax)),
              if (shipping > 0)
                _buildSummaryRow('ຄ່າຈັດສົ່ງ:', _formatCurrency(shipping)),
              const Divider(height: 24),
              _buildSummaryRow(
                'ລວມທັງໝົດ:',
                _formatCurrency(total),
                isTotal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.notoSansLaoLooped(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '$value ກີບ',
            style: GoogleFonts.notoSansLaoLooped(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.blue[700] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                'ກັບໄປ',
                style: GoogleFonts.notoSansLaoLooped(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: สั่งซื้ออีกครั้ง
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'ເພີ່ມໃສ່ກະຕ່າສຳເລັດແລ້ວ',
                      style: GoogleFonts.notoSansLaoLooped(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(
                'ສັ່ງຊື້ອີກ',
                style: GoogleFonts.notoSansLaoLooped(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
