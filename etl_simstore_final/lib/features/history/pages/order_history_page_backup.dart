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
  OrderStatus? _filterStatus;

  final List<Order> _sampleOrders = [
    Order(
      id: 'ORD-001',
      userId: 'user-1',
      userEmail: 'customer@example.com',
      userName: 'ວົງສະຫວັນ ພົມມະວົງ',
      phoneNumber: '02023655890',
      type: OrderType.simCard,
      status: OrderStatus.delivered,
      items: [
        const OrderItem(
          id: '1',
          productId: 'sim-001',
          productName: 'ຊິມກາດເປີຍ່າຈ່າຍ',
          quantity: 1,
          unitPrice: 50000,
          totalPrice: 50000,
          description: 'ເບີໂທ: 02023655890',
        ),
      ],
      subtotal: 50000,
      tax: 0,
      shipping: 0,
      totalAmount: 50000,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: 'ORD-002',
      userId: 'user-1',
      userEmail: 'customer@example.com',
      userName: 'ວົງສະຫວັນ ພົມມະວົງ',
      phoneNumber: '02055512345',
      type: OrderType.dataPackage,
      status: OrderStatus.processing,
      items: [
        const OrderItem(
          id: '2',
          productId: 'pkg-001',
          productName: 'ແພັກເກດຂໍ້ມູນ 10GB',
          quantity: 1,
          unitPrice: 120000,
          totalPrice: 120000,
          description: 'ໄວ 30 ວັນ',
        ),
      ],
      subtotal: 120000,
      tax: 0,
      shipping: 0,
      totalAmount: 120000,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Order(
      id: 'ORD-003',
      userId: 'user-1',
      userEmail: 'customer@example.com',
      userName: 'ວົງສະຫວັນ ພົມມະວົງ',
      phoneNumber: '02098765432',
      type: OrderType.ftth,
      status: OrderStatus.cancelled,
      items: [
        const OrderItem(
          id: '3',
          productId: 'ftth-001',
          productName: 'FTTH 100 Mbps',
          quantity: 1,
          unitPrice: 500000,
          totalPrice: 500000,
          description: 'ຕິດຕັ້ງທີ່ບ້ານ',
        ),
      ],
      subtotal: 500000,
      tax: 50000,
      shipping: 0,
      totalAmount: 550000,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavbarLogout(),
      body: Column(
        children: [
          _buildPageHeader(),
          _buildSearchAndFilter(),
          _buildStatusTabs(),
          Expanded(child: _buildOrderList()),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
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
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ປະຫວັດການສັ່ງຊື້',
                  style: GoogleFonts.notoSansLaoLooped(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ເບິ່ງຄຳສັ່ງຊື້ທັງໝົດຂອງທ່ານ',
                  style: GoogleFonts.notoSansLaoLooped(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_getFilteredOrders().length} ຄຳສັ່ງ',
              style: GoogleFonts.notoSansLaoLooped(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາເລກທີຄຳສັ່ງ ຫຼື ເບີໂທ...',
                hintStyle: GoogleFonts.notoSansLaoLooped(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: GoogleFonts.notoSansLaoLooped(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: PopupMenuButton<OrderStatus?>(
              icon: const Icon(Icons.filter_list),
              onSelected: (status) {
                setState(() {
                  _filterStatus = status;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: null,
                  child: Text('ທັງໝົດ', style: GoogleFonts.notoSansLaoLooped()),
                ),
                ...OrderStatus.values.map(
                  (status) => PopupMenuItem(
                    value: status,
                    child: Text(
                      status.displayName,
                      style: GoogleFonts.notoSansLaoLooped(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[700],
        labelStyle: GoogleFonts.notoSansLaoLooped(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.notoSansLaoLooped(),
        tabs: [
          Tab(text: 'ທັງໝົດ (${_sampleOrders.length})'),
          Tab(
            text:
                'ກຳລັງດຳເນີນ (${_sampleOrders.where((o) => o.isActive).length})',
          ),
          Tab(
            text:
                'ສຳເລັດ (${_sampleOrders.where((o) => o.isCompleted).length})',
          ),
          Tab(
            text:
                'ຍົກເລີກ (${_sampleOrders.where((o) => o.isCancelled).length})',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOrderListTab(_getFilteredOrders()),
        _buildOrderListTab(
          _getFilteredOrders().where((o) => o.isActive).toList(),
        ),
        _buildOrderListTab(
          _getFilteredOrders().where((o) => o.isCompleted).toList(),
        ),
        _buildOrderListTab(
          _getFilteredOrders().where((o) => o.isCancelled).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderListTab(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'ບໍ່ມີຄຳສັ່ງຊື້',
              style: GoogleFonts.notoSansLaoLooped(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ເມື່ອທ່ານສັ່ງຊື້ ຄຳສັ່ງຈະປາກົດທີ່ນີ້',
              style: GoogleFonts.notoSansLaoLooped(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: GoogleFonts.notoSansLaoLooped(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(order.createdAt),
                        style: GoogleFonts.notoSansLaoLooped(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _getOrderTypeIcon(order.type),
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.type.displayName,
                    style: GoogleFonts.notoSansLaoLooped(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_formatCurrency(order.totalAmount)} ກີບ',
                    style: GoogleFonts.notoSansLaoLooped(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'ສິນຄ້າ: ${order.items.map((item) => item.productName).join(', ')}',
                style: GoogleFonts.notoSansLaoLooped(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (order.phoneNumber != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      order.phoneNumber!,
                      style: GoogleFonts.notoSansLaoLooped(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(order: order),
                          ),
                        );
                      },
                      child: Text(
                        'ເບິ່ງລາຍລະອຽດ',
                        style: GoogleFonts.notoSansLaoLooped(),
                      ),
                    ),
                  ),
                  if (order.status == OrderStatus.delivered) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'ສັ່ງຊື້ອີກ',
                          style: GoogleFonts.notoSansLaoLooped(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        status.displayName,
        style: GoogleFonts.notoSansLaoLooped(
          color: chipColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  IconData _getOrderTypeIcon(OrderType type) {
    switch (type) {
      case OrderType.simCard:
        return Icons.sim_card;
      case OrderType.dataPackage:
        return Icons.data_usage;
      case OrderType.ftth:
        return Icons.router;
      case OrderType.other:
        return Icons.inventory;
    }
  }

  List<Order> _getFilteredOrders() {
    var filtered = _sampleOrders.where((order) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return order.id.toLowerCase().contains(query) ||
            (order.phoneNumber?.contains(query) ?? false);
      }
      return true;
    });

    if (_filterStatus != null) {
      filtered = filtered.where((order) => order.status == _filterStatus);
    }

    return filtered.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
