import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/sim_card_model.dart';
import '../../../home/controllers/main_menu_bar.dart';
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
  final TextEditingController _wantedNumbersController =
      TextEditingController();
  final TextEditingController _unwantedNumbersController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _wantedNumbersController.dispose();
    _unwantedNumbersController.dispose();
    super.dispose();
  }

  Color _getTypeColor(SimCardType type) {
    switch (type) {
      case SimCardType.prepaid:
        return const Color(0xFF1976D2); // blue
      case SimCardType.tourist:
        return const Color(0xFF43A047); // green
    }
  }

  void _showPriceFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ເລືອກລາຄາ',
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

  void _showFilterHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ວິທີໃຊ້ງານຕົວກອງ',
          style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'ກະລຸນາປ້ອນເບີທີ່ຕ້ອງການ ຫຼື ເບີທີ່ບໍ່ຕ້ອງການໃນຊ່ອງທີ່ກຳນົດ',
          style: GoogleFonts.notoSansLao(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ເຂົ້າໃຈແລ້ວ', style: GoogleFonts.notoSansLao()),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    _searchController.clear();
    _wantedNumbersController.clear();
    _unwantedNumbersController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(wantedNumbersProvider.notifier).state = '';
    ref.read(unwantedNumbersProvider.notifier).state = '';
    ref.read(simTypeFilterProvider.notifier).state = null;
    ref.read(priceRangeFilterProvider.notifier).state = null;
    _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final filteredSims = ref.watch(filteredSimCardsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: const MainMenuBar(),
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
                Row(
                  children: [
                    // Wanted Numbers Filter
                    Expanded(
                      child: TextField(
                        controller: _wantedNumbersController,
                        onChanged: (value) {
                          ref.read(wantedNumbersProvider.notifier).state =
                              value;
                        },
                        decoration: InputDecoration(
                          hintText: 'ເບີທີ່ຕ້ອງການ (ເຊັ່ນ: 888, 999)',
                          hintStyle: GoogleFonts.notoSansLao(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.favorite,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                        style: GoogleFonts.notoSansLao(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unwanted Numbers Filter
                    Expanded(
                      child: TextField(
                        controller: _unwantedNumbersController,
                        onChanged: (value) {
                          ref.read(unwantedNumbersProvider.notifier).state =
                              value;
                        },
                        decoration: InputDecoration(
                          hintText: 'ເບີທີ່ບໍ່ຕ້ອງການ (ເຊັ່ນ: 4, 666)',
                          hintStyle: GoogleFonts.notoSansLao(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        style: GoogleFonts.notoSansLao(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Clear Filters Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ຜົນການກອງ',
                          style: GoogleFonts.notoSansLao(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        IconButton(
                          onPressed: _showFilterHelpDialog,
                          icon: const Icon(Icons.help_outline, size: 18),
                          tooltip: 'ວິທີໃຊ້ງານຕົວກອງ',
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _clearAllFilters();
                      },
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: Text(
                        'ລຶບຕົວກອງທັງໝົດ',
                        style: GoogleFonts.notoSansLao(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
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
                        selectedType = SimCardType.tourist;
                        break;
                      default:
                        selectedType = null;
                    }
                    ref.read(simTypeFilterProvider.notifier).state =
                        selectedType;
                  },
                  tabs: const [
                    Tab(text: 'ທັງໝົດ'),
                    Tab(text: 'ເບີໂທລະສັບມືຖື(ແບບຕື່ມເງິນ)'),
                    Tab(text: 'ຊິມລວມແພັກເກັດສຳຫລັບນັກທ່ອງທ່ຽວ'),
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
                    'ເລືອກລາຄາ',
                    style: GoogleFonts.notoSansLao(
                      color: const Color.fromARGB(255, 22, 53, 134),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =============================
          // ส่วนแสดงรายการซิมการ์ด (SIM Cards List)
          // =============================
          Expanded(
            child: filteredSims.when(
              // ถ้ามีข้อมูลซิม
              data: (sims) {
                // ถ้าไม่มีซิมที่ตรงกับเงื่อนไข
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

                // Responsive: กำหนดจำนวนคอลัมน์ตามขนาดหน้าจอ
                final width = MediaQuery.of(context).size.width;
                final crossAxisCount = width < 600 ? 1 : (width < 900 ? 2 : 3);
                // แสดงรายการซิมใน GridView
                return GridView.builder(
                  padding: const EdgeInsets.all(30),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount, // จำนวนคอลัมน์
                    childAspectRatio: 0.75, // อัตราส่วนกว้าง:สูง ของแต่ละช่อง
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: sims.length,
                  itemBuilder: (context, index) {
                    final sim = sims[index];
                    // เรียกใช้ widget สำหรับแสดงข้อมูลแต่ละซิม
                    return _buildSimCard(context, sim);
                  },
                );
              },
              // กำลังโหลดข้อมูล
              loading: () => const Center(child: CircularProgressIndicator()),
              // ถ้าเกิด error
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

  // =============================
  // Widget สำหรับแสดงข้อมูลซิมแต่ละใบ (SIM Card)
  // =============================
  Widget _buildSimCard(BuildContext context, SimCard sim) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // เมื่อกดที่ซิม จะไปหน้า SimDetailPage
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SimDetailPage(simCard: sim),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: SizedBox(
            height: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge แสดงประเภทซิม (prepaid/tourist)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(sim.type),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    sim.type.displayName,
                    style: GoogleFonts.notoSansLao(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // โลโก้ ETL ตรงกลาง
                const SizedBox(height: 4),
                // แสดงเบอร์โทรศัพท์
                Text(
                  sim.phoneNumber,
                  style: GoogleFonts.notoSansLao(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 22, 53, 134),
                  ),
                ),
                // แสดงชื่อแพ็กเกจ (ถ้ามี)
                if (sim.packageName != null)
                  Text(
                    sim.packageName!,
                    style: GoogleFonts.notoSansLao(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Center(
                  child: Image.asset(
                    'assets/ETL_logo.jpg',
                    width: 150,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                // แสดงราคา และ badge "เบอร์พิเศษ" ถ้าเป็นเบอร์สวย
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
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          if (sim.isSpecialNumber)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'ເບີພິເສດ',
                                style: GoogleFonts.notoSansLao(
                                  fontSize: 8,
                                  color: Colors.brown[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
