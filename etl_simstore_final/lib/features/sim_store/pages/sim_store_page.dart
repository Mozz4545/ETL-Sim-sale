import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/sim_card_model.dart';
import '../../../features/home/controllers/custom_navbar_logout.dart';
import '../providers/sim_store_provider.dart';
import 'sim_detail_page.dart';
import 'cart_page.dart';

class SimStorePage extends ConsumerStatefulWidget {
  const SimStorePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SimStorePage> createState() => _SimStorePageState();
}

class _SimStorePageState extends ConsumerState<SimStorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSims = ref.watch(filteredSimCardsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: Column(
        children: [
          // Search and Filter Section
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
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'ຄົ້ນຫາເບີໂທ...',
                    hintStyle: GoogleFonts.notoSansLao(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
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
                ),
                const SizedBox(height: 16),

                // Filter Tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color.fromARGB(255, 22, 53, 134),
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: const Color.fromARGB(255, 22, 53, 134),
                  labelStyle: GoogleFonts.notoSansLao(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.notoSansLao(),
                  onTap: (index) {
                    SimCardType? selectedType;
                    switch (index) {
                      case 1:
                        selectedType = SimCardType.prepaid;
                        break;
                      case 2:
                        selectedType = SimCardType.postpaid;
                        break;
                      case 3:
                        selectedType = SimCardType.tourist;
                        break;
                      case 4:
                        selectedType = SimCardType.business;
                        break;
                      default:
                        selectedType = null;
                    }
                    ref.read(simTypeFilterProvider.notifier).state =
                        selectedType;
                  },
                  tabs: const [
                    Tab(text: 'ທັງໝົດ'),
                    Tab(text: 'ເປີຍ່າຈ່າຍ'),
                    Tab(text: 'ຈ່າຍຫຼັງ'),
                    Tab(text: 'ນັກທ່ອງທ່ຽວ'),
                    Tab(text: 'ທຸລະກິດ'),
                  ],
                ),
              ],
            ),
          ),

          // Price Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ລາຄາ:',
                    style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: () => _showPriceFilterDialog(context),
                  child: Text(
                    'ກັ່ນຕອງລາຄາ',
                    style: GoogleFonts.notoSansLao(
                      color: const Color.fromARGB(255, 22, 53, 134),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SIM Cards List
          Expanded(
            child: filteredSims.when(
              data: (sims) {
                if (sims.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sim_card_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ບໍ່ພົບຊິມກາດ',
                          style: GoogleFonts.notoSansLao(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: sims.length,
                  itemBuilder: (context, index) {
                    final sim = sims[index];
                    return _buildSimCard(context, sim);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'ເກີດຂໍ້ຜິດພາດ',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 18,
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: GoogleFonts.notoSansLao(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              backgroundColor: const Color.fromARGB(255, 22, 53, 134),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                'ກະຕ່າ (${cart.length})',
                style: GoogleFonts.notoSansLao(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSimCard(BuildContext context, SimCard sim) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SimDetailPage(simCard: sim),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SIM Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(sim.type),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sim.type.displayName,
                  style: GoogleFonts.notoSansLao(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Phone Number
              Text(
                sim.phoneNumber,
                style: GoogleFonts.notoSansLao(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 22, 53, 134),
                ),
              ),
              const SizedBox(height: 4),

              // Package Name
              if (sim.packageName != null)
                Text(
                  sim.packageName!,
                  style: GoogleFonts.notoSansLao(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const Spacer(),

              // Price and Features
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${sim.price.toStringAsFixed(0)} ກີບ',
                          style: GoogleFonts.notoSansLao(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                        if (sim.isSpecialNumber)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ເບີພິເສດ',
                              style: GoogleFonts.notoSansLao(
                                fontSize: 8,
                                color: Colors.amber[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addToCart(sim);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'ເພີ່ມ ${sim.phoneNumber} ເຂົ້າກະຕ່າແລ້ວ',
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
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart,
                      color: Color.fromARGB(255, 22, 53, 134),
                    ),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(SimCardType type) {
    switch (type) {
      case SimCardType.prepaid:
        return Colors.blue;
      case SimCardType.postpaid:
        return Colors.green;
      case SimCardType.tourist:
        return Colors.orange;
      case SimCardType.business:
        return Colors.purple;
    }
  }

  void _showPriceFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ກັ່ນຕອງລາຄາ',
          style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('ທັງໝົດ', style: GoogleFonts.notoSansLao()),
              onTap: () {
                ref.read(priceRangeFilterProvider.notifier).state = null;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                'ຕ່ຳກວ່າ 100,000 ກີບ',
                style: GoogleFonts.notoSansLao(),
              ),
              onTap: () {
                ref.read(priceRangeFilterProvider.notifier).state = PriceRange(
                  min: 0,
                  max: 100000,
                );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                '100,000 - 500,000 ກີບ',
                style: GoogleFonts.notoSansLao(),
              ),
              onTap: () {
                ref.read(priceRangeFilterProvider.notifier).state = PriceRange(
                  min: 100000,
                  max: 500000,
                );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                'ສູງກວ່າ 500,000 ກີບ',
                style: GoogleFonts.notoSansLao(),
              ),
              onTap: () {
                ref.read(priceRangeFilterProvider.notifier).state = PriceRange(
                  min: 500000,
                  max: double.infinity,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
