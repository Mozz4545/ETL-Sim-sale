import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/sim_card_model.dart';
import '../../../home/controllers/main_menu_bar.dart';
import '../providers/sim_store_provider.dart';

class SimDetailPage extends ConsumerWidget {
  final SimCard simCard;

  const SimDetailPage({super.key, required this.simCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MainMenuBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SIM Card Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SIM Card Details',
                          style: GoogleFonts.notoSansLao(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(simCard.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStatusIcon(simCard.status),
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                simCard.status.displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      simCard.phoneNumber,
                      style: GoogleFonts.robotoMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    if (simCard.isSpecialNumber)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[800],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'หมายเลขพิเศษ',
                              style: TextStyle(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Price Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('ຂໍ້ມູນລາຄາ'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'ລາຄາຊື້:',
                      '${simCard.price.toStringAsFixed(0)} ກີບ',
                      Icons.monetization_on,
                    ),
                    if (simCard.monthlyFee != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'ຄ່າບໍລິການລາຍເດືອນ:',
                        '${simCard.monthlyFee!.toStringAsFixed(0)} ກີບ',
                        Icons.calendar_month,
                      ),
                    ],
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'ປະເພດ:',
                      simCard.type.displayName,
                      Icons.category,
                    ),
                    if (simCard.packageName != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'ແພັກເກັດ:',
                        simCard.packageName!,
                        Icons.inventory,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Features
            if (simCard.features?.isNotEmpty == true) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('ຄຸນສົມບັດ'),
                      const SizedBox(height: 12),
                      ...simCard.features!.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: GoogleFonts.notoSansLao(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Status Information
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('ສະຖານະ'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'ສະຖານະປັດຈຸບັນ:',
                      simCard.status.displayName,
                      _getStatusIcon(simCard.status),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'ວັນທີ່ສ້າງ:',
                      '${simCard.createdAt.day}/${simCard.createdAt.month}/${simCard.createdAt.year}',
                      Icons.date_range,
                    ),
                  ],
                ),
              ),
            ),

            // Notes
            if (simCard.notes != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('ໝາຍເຫດ'),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          simCard.notes!,
                          style: GoogleFonts.notoSansLao(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Action Buttons
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: simCard.status == SimCardStatus.available
                        ? () {
                            ref.read(cartProvider.notifier).addToCart(simCard);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ເພີ່ມໃສ່ກະຕ່າແລ້ວ'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('ເພີ່ມໃສ່ກະຕ່າ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: simCard.status == SimCardStatus.available
                        ? () {
                            // Reserve SIM logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ຈອງ SIM ສຳເລັດແລ້ວ'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('ຈອງ SIM'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.notoSansLao(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.notoSansLao(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.notoSansLao(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(SimCardStatus status) {
    switch (status) {
      case SimCardStatus.available:
        return Colors.green;
      case SimCardStatus.reserved:
        return Colors.orange;
      case SimCardStatus.sold:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(SimCardStatus status) {
    switch (status) {
      case SimCardStatus.available:
        return Icons.check_circle;
      case SimCardStatus.reserved:
        return Icons.schedule;
      case SimCardStatus.sold:
        return Icons.cancel;
    }
  }
}
