import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../home/controllers/main_menu_bar.dart';
import '../providers/sim_store_provider.dart';
import '../../../checkout/pages/checkout_page.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: const MainMenuBar(),
      body: cart.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // Cart Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Color.fromARGB(255, 22, 53, 134),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ກະຕ່າຊື້ຂອງ (${cart.length} ລາຍການ)',
                        style: GoogleFonts.notoSansLao(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 22, 53, 134),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _buildCartItem(context, item, cartNotifier);
                    },
                  ),
                ),

                // Cart Summary
                _buildCartSummary(context, cartNotifier),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'ກະຕ່າຂອງທ່ານຍັງວ່າງ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ເລືອກຊິມກາດທີ່ທ່ານຕ້ອງການ',
            style: GoogleFonts.notoSansLao(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 22, 53, 134),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(
              'ໄປຊື້ຊິມກາດ',
              style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartNotifier cartNotifier,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.simNumber,
                        style: GoogleFonts.notoSansLao(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 22, 53, 134),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.packageName,
                        style: GoogleFonts.notoSansLao(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => cartNotifier.removeFromCart(item.id),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quantity and Price
            Row(
              children: [
                // Quantity Controls
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: item.quantity > 1
                            ? () => cartNotifier.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              )
                            : null,
                        icon: const Icon(Icons.remove, size: 16),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          item.quantity.toString(),
                          style: GoogleFonts.notoSansLao(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cartNotifier.updateQuantity(
                          item.id,
                          item.quantity + 1,
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (item.quantity > 1)
                      Text(
                        '${item.price.toStringAsFixed(0)} ກີບ × ${item.quantity}',
                        style: GoogleFonts.notoSansLao(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    Text(
                      '${item.totalPrice.toStringAsFixed(0)} ກີບ',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartNotifier cartNotifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Items
          Row(
            children: [
              Text(
                'ລວມ ${cartNotifier.totalItems} ລາຍການ',
                style: GoogleFonts.notoSansLao(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '${cartNotifier.totalAmount.toStringAsFixed(0)} ກີບ',
                style: GoogleFonts.notoSansLao(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 22, 53, 134),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              // Clear Cart Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'ລົບກະຕ່າ',
                          style: GoogleFonts.notoSansLao(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: Text(
                          'ທ່ານຕ້ອງການລົບລາຍການທັງໝົດໃນກະຕ່າບໍ?',
                          style: GoogleFonts.notoSansLao(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'ຍົກເລີກ',
                              style: GoogleFonts.notoSansLao(),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              cartNotifier.clearCart();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'ລົບ',
                              style: GoogleFonts.notoSansLao(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'ລົບທັງໝົດ',
                    style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Checkout Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    'ດຳເນີນການສັ່ງຊື້',
                    style: GoogleFonts.notoSansLao(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
