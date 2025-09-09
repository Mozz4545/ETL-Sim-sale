import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../home/controllers/main_menu_bar.dart';
import '../../sim_store/providers/sim_store_provider.dart';
import '../../auth/provider/auth_provider.dart';

import '../../../core/models/order_model.dart' as models;

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  models.PaymentMethod? _selectedPayment;

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final user = ref.watch(authProvider);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: const MainMenuBar(),
        body: _buildEmptyCart(context),
      );
    }

    return Scaffold(
      appBar: const MainMenuBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                      Icons.receipt_long,
                      color: Color.fromARGB(255, 22, 53, 134),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ຢືນຢັນການສັ່ງຊື້',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 22, 53, 134),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Information
                    _buildSectionTitle('ຂໍ້ມູນລູກຄ້າ'),
                    const SizedBox(height: 12),
                    Container(
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
                            user.user?.displayName ?? 'ບໍ່ມີຊື່',
                            style: GoogleFonts.notoSansLao(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.user?.email ?? '',
                            style: GoogleFonts.notoSansLao(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    _buildSectionTitle('ວິທີການຈ່າຍເງິນ'),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          RadioListTile<models.PaymentMethod>(
                            value: models.PaymentMethod.cashOnDelivery,
                            groupValue: _selectedPayment,
                            onChanged: (val) =>
                                setState(() => _selectedPayment = val),
                            title: Text(
                              'ຈ່າຍເງິນປາຍທາງ',
                              style: GoogleFonts.notoSansLao(),
                            ),
                          ),
                          const Divider(height: 1),
                          RadioListTile<models.PaymentMethod>(
                            value: models.PaymentMethod.bankTransfer,
                            groupValue: _selectedPayment,
                            onChanged: (val) =>
                                setState(() => _selectedPayment = val),
                            title: Text(
                              'ໂອນຜ່ານທະນາຄານ',
                              style: GoogleFonts.notoSansLao(),
                            ),
                          ),
                          const Divider(height: 1),
                          RadioListTile<models.PaymentMethod>(
                            value: models.PaymentMethod.qrPayment,
                            groupValue: _selectedPayment,
                            onChanged: (val) =>
                                setState(() => _selectedPayment = val),
                            title: Text(
                              'QR ພາຍໃນປະເທດ',
                              style: GoogleFonts.notoSansLao(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contact Information
                    _buildSectionTitle('ຂໍ້ມູນການຕິດຕໍ່'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'ເບີໂທ *',
                        labelStyle: GoogleFonts.notoSansLao(),
                        hintText: '020 XXXX XXXX',
                        hintStyle: GoogleFonts.notoSansLao(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 22, 53, 134),
                            width: 2,
                          ),
                        ),
                      ),
                      style: GoogleFonts.notoSansLao(),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາປ້ອນເບີໂທ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'ທີ່ຢູ່ຈັດສົ່ງ *',
                        labelStyle: GoogleFonts.notoSansLao(),
                        hintText: 'ປ້ອນທີ່ຢູ່ສຳລັບການຈັດສົ່ງ',
                        hintStyle: GoogleFonts.notoSansLao(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 22, 53, 134),
                            width: 2,
                          ),
                        ),
                      ),
                      style: GoogleFonts.notoSansLao(),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາປ້ອນທີ່ຢູ່';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'ໝາຍເຫດ (ຖ້າມີ)',
                        labelStyle: GoogleFonts.notoSansLao(),
                        hintText: 'ຂໍ້ມູນເພີ່ມເຕີມສຳລັບການສັ່ງຊື້',
                        hintStyle: GoogleFonts.notoSansLao(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 22, 53, 134),
                            width: 2,
                          ),
                        ),
                      ),
                      style: GoogleFonts.notoSansLao(),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    // Order Summary
                    _buildSectionTitle('ສະຫຼຸບການສັ່ງຊື້'),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: _buildOrderList(context),
                    ),
                    const SizedBox(height: 16),

                    // Total
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          22,
                          53,
                          134,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 22, 53, 134),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'ລວມທັງໝົດ:',
                            style: GoogleFonts.notoSansLao(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                    ),
                    const SizedBox(height: 24),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            22,
                            53,
                            134,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'ຢືນຢັນການສັ່ງຊື້',
                                style: GoogleFonts.notoSansLao(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              'ກັບໄປຊື້ຊິມກາດ',
              style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
            ),
          ),
        ],
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

  Widget _buildOrderList(BuildContext context) {
    final cart = ref.watch(cartProvider);

    if (cart.isEmpty) {
      return Center(
        child: Text(
          'ຍັງບໍ່ມີສິນຄ້າ',
          style: GoogleFonts.notoSansLao(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final item = cart[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.simNumber,
                      style: GoogleFonts.notoSansLao(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.packageName,
                      style: GoogleFonts.notoSansLao(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'x${item.quantity}',
                style: GoogleFonts.notoSansLao(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.totalPrice.toStringAsFixed(0)} ກີບ',
                style: GoogleFonts.notoSansLao(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPayment == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ກະລຸນາເລືອກວິທີຈ່າຍເງິນ',
              style: GoogleFonts.notoSansLao(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final userObj = ref.read(authProvider).user;
    if (userObj == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ກະລຸນາເຂົ້າສູ່ລະບົບກ່ອນ',
              style: GoogleFonts.notoSansLao(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cartItems = ref.read(cartProvider);

      final orderRef = FirebaseDatabase.instance.ref('orders').push();
      await orderRef.set({
        'userId': userObj.uid,
        'userEmail': userObj.email ?? '',
        'userName': userObj.displayName,
        'phoneNumber': _phoneController.text,
        'deliveryAddress': _addressController.text,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'paymentMethod': _selectedPayment!.toString(),
        'cartItems': cartItems
            .map(
              (item) => {
                'simNumber': item.simNumber,
                'packageName': item.packageName,
                'quantity': item.quantity,
                'totalPrice': item.totalPrice,
              },
            )
            .toList(),
      });

      // Clear cart
      ref.read(cartProvider.notifier).clearCart();

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              'ສຳເລັດ!',
              style: GoogleFonts.notoSansLao(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
            content: Text(
              'ການສັ່ງຊື້ຂອງທ່ານສຳເລັດແລ້ວ\nເຮົາຈະຕິດຕໍ່ກັບທ່ານໃນໄວໆນີ້',
              style: GoogleFonts.notoSansLao(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushReplacementNamed('/order-history');
                },
                child: Text(
                  'ເບິ່ງປະຫວັດການສັ່ງຊື້',
                  style: GoogleFonts.notoSansLao(
                    color: const Color.fromARGB(255, 22, 53, 134),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ເກີດຂໍ້ຜິດພາດ: ${e.toString()}',
              style: GoogleFonts.notoSansLao(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Removed misplaced import
}
