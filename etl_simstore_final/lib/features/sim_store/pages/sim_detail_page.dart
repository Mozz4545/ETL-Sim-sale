import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/sim_card_model.dart';
import '../../../features/home/controllers/custom_navbar_logout.dart';
import '../providers/sim_store_provider.dart';

class SimDetailPage extends ConsumerWidget {
  final SimCard simCard;

  const SimDetailPage({Key? key, required this.simCard}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 22, 53, 134),
                    const Color.fromARGB(255, 22, 53, 134).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SIM Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      simCard.type.displayName,
                      style: GoogleFonts.notoSansLao(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  Text(
                    simCard.phoneNumber,
                    style: GoogleFonts.notoSansLao(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${simCard.price.toStringAsFixed(0)} ກີບ',
                        style: GoogleFonts.notoSansLao(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (simCard.isSpecialNumber) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ເບີພິເສດ',
                            style: GoogleFonts.notoSansLao(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Information
                  if (simCard.packageName != null) ...[
                    _buildSectionTitle('ແພັກເກດ'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            simCard.packageName!,
                            style: GoogleFonts.notoSansLao(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 22, 53, 134),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ຄ່າບໍລິການລາຍເດືອນ: ${simCard.monthlyFee.toStringAsFixed(0)} ກີບ',
                            style: GoogleFonts.notoSansLao(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Features
                  if (simCard.features.isNotEmpty) ...[
                    _buildSectionTitle('ຄຸນສົມບັດ'),
                    const SizedBox(height: 12),
                    ...simCard.features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: GoogleFonts.notoSansLao(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Status Information
                  _buildSectionTitle('ສະຖານະ'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(simCard.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(simCard.status),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(simCard.status),
                          color: _getStatusColor(simCard.status),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          simCard.status.displayName,
                          style: GoogleFonts.notoSansLao(
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(simCard.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Additional Information
                  if (simCard.notes != null) ...[
                    _buildSectionTitle('ຂໍ້ມູນເພີ່ມເຕີມ'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        simCard.notes!,
                        style: GoogleFonts.notoSansLao(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: simCard.status == SimCardStatus.available
                          ? () {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(simCard);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'ເພີ່ມ ${simCard.phoneNumber} ເຂົ້າກະຕ່າແລ້ວ',
                                    style: GoogleFonts.notoSansLao(),
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    22,
                                    53,
                                    134,
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_shopping_cart),
                          const SizedBox(width: 8),
                          Text(
                            simCard.status == SimCardStatus.available
                                ? 'ເພີ່ມເຂົ້າກະຕ່າ'
                                : 'ບໍ່ສາມາດສັ່ງຊື້ໄດ້',
                            style: GoogleFonts.notoSansLao(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        fontWeight: FontWeight.w700,
        color: const Color.fromARGB(255, 22, 53, 134),
      ),
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
      case SimCardStatus.suspended:
        return Colors.grey;
      case SimCardStatus.expired:
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
      case SimCardStatus.suspended:
        return Icons.pause_circle;
      case SimCardStatus.expired:
        return Icons.cancel;
    }
  }
}
