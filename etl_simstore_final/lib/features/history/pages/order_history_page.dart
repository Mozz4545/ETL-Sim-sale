import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/provider/auth_provider.dart';
import '../../home/controllers/custom_navbar_logout.dart';
import '../../checkout/services/order_service.dart';
import '../../../core/models/order_model.dart';
import 'order_detail_page.dart';

// Order Service Provider
final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

// User Orders Provider
final userOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return [];

  final orderService = ref.read(orderServiceProvider);
  return orderService.getUserOrders(user.uid);
});

class OrderHistoryPage extends ConsumerStatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: Column(
        children: [
          _buildPageHeader(),
          _buildSearchBar(),
          _buildTabBar(ordersAsync),
          _buildOrdersList(ordersAsync),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
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
          Icon(
            Icons.history,
            color: const Color.fromARGB(255, 22, 53, 134),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'ປະຫວັດການສັ່ງຊື້',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color.fromARGB(255, 22, 53, 134),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'ຄົ້ນຫາເລກທີ່ອໍເດີຫຼືເບີໂທ...',
          hintStyle: GoogleFonts.notoSansLao(color: Colors.grey[600]),
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 22, 53, 134),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
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
    );
  }

  Widget _buildTabBar(AsyncValue<List<Order>> ordersAsync) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color.fromARGB(255, 22, 53, 134),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color.fromARGB(255, 22, 53, 134),
        labelStyle: GoogleFonts.notoSansLao(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansLao(fontSize: 14),
        onTap: (index) {
          setState(() {}); // Rebuild to update the list
        },
        tabs: ordersAsync.when(
          data: (orders) => [
            Tab(text: 'ທັງໝົດ (${orders.length})'),
            Tab(
              text: 'ກຳລັງດຳເນີນ (${orders.where((o) => o.isActive).length})',
            ),
            Tab(text: 'ສຳເລັດ (${orders.where((o) => o.isCompleted).length})'),
            Tab(text: 'ຍົກເລີກ (${orders.where((o) => o.isCancelled).length})'),
          ],
          loading: () => const [
            Tab(text: 'ທັງໝົດ'),
            Tab(text: 'ກຳລັງດຳເນີນ'),
            Tab(text: 'ສຳເລັດ'),
            Tab(text: 'ຍົກເລີກ'),
          ],
          error: (_, __) => const [
            Tab(text: 'ທັງໝົດ'),
            Tab(text: 'ກຳລັງດຳເນີນ'),
            Tab(text: 'ສຳເລັດ'),
            Tab(text: 'ຍົກເລີກ'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(AsyncValue<List<Order>> ordersAsync) {
    return Expanded(
      child: ordersAsync.when(
        data: (orders) {
          // Filter orders based on current tab
          List<Order> filteredOrders = orders;

          switch (_tabController.index) {
            case 1: // กำลังดำเนินการ
              filteredOrders = orders.where((order) => order.isActive).toList();
              break;
            case 2: // เสร็จสิ้น
              filteredOrders = orders
                  .where((order) => order.isCompleted)
                  .toList();
              break;
            case 3: // ยกเลิก
              filteredOrders = orders
                  .where((order) => order.isCancelled)
                  .toList();
              break;
            default: // ทั้งหมด
              break;
          }

          // Apply search filter
          if (_searchQuery.isNotEmpty) {
            filteredOrders = filteredOrders.where((order) {
              final query = _searchQuery.toLowerCase();
              return order.id.toLowerCase().contains(query) ||
                  order.phoneNumber?.toLowerCase().contains(query) == true ||
                  order.items.any(
                    (item) => item.productName.toLowerCase().contains(query),
                  );
            }).toList();
          }

          if (filteredOrders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(filteredOrders[index]);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 22, 53, 134),
          ),
        ),
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
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: GoogleFonts.notoSansLao(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(userOrdersProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 53, 134),
                  foregroundColor: Colors.white,
                ),
                child: Text('ລອງໃໝ່', style: GoogleFonts.notoSansLao()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'ບໍ່ມີປະຫວັດການສັ່ງຊື້',
            style: GoogleFonts.notoSansLao(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ເລີ່ມສັ່ງຊື້ຊິມກາດກັບພວກເຮົາ',
            style: GoogleFonts.notoSansLao(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/sim-store'),
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

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OrderDetailPage()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ອໍເດີ #${order.id}',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 22, 53, 134),
                      ),
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 8),

              // Order Date
              Text(
                'ວັນທີ່: ${_formatDate(order.createdAt)}',
                style: GoogleFonts.notoSansLao(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              // Order Items Summary
              if (order.items.isNotEmpty) ...[
                Text(
                  order.items.first.productName,
                  style: GoogleFonts.notoSansLao(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (order.items.length > 1)
                  Text(
                    'ແລະອີກ ${order.items.length - 1} ລາຍການ',
                    style: GoogleFonts.notoSansLao(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 8),
              ],

              // Order Total and Phone
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ລວມ: ${order.totalAmount.toStringAsFixed(0)} ກີບ',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  if (order.phoneNumber != null)
                    Text(
                      order.phoneNumber!,
                      style: GoogleFonts.notoSansLao(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        icon = Icons.schedule;
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.processing:
        backgroundColor = Colors.purple[100]!;
        textColor = Colors.purple[800]!;
        icon = Icons.settings;
        break;
      case OrderStatus.shipped:
        backgroundColor = Colors.indigo[100]!;
        textColor = Colors.indigo[800]!;
        icon = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        icon = Icons.cancel;
        break;
      case OrderStatus.rejected:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        icon = Icons.block;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: GoogleFonts.notoSansLao(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
