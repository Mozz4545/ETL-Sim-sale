import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/order_model.dart' as models;
import '../../sim_store/providers/sim_store_provider.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createOrder({
    required String userId,
    required String userEmail,
    String? userName,
    required String phoneNumber,
    required String deliveryAddress,
    String? notes,
    required List<CartItem> cartItems,
  }) async {
    try {
      // Calculate totals
      final subtotal = cartItems.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      final tax = subtotal * 0.1; // 10% tax
      const shipping = 20000.0; // Fixed shipping cost
      final totalAmount = subtotal + tax + shipping;

      // Convert cart items to order items
      final orderItems = cartItems.map((cartItem) {
        return models.OrderItem(
          id: cartItem.id,
          productId: cartItem.simId,
          productName: '${cartItem.simNumber} - ${cartItem.packageName}',
          quantity: cartItem.quantity,
          unitPrice: cartItem.price,
          totalPrice: cartItem.totalPrice,
          description: cartItem.packageName,
        );
      }).toList();

      // Create order document
      final orderRef = _db.collection('orders').doc();
      final order = models.Order(
        id: orderRef.id,
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        phoneNumber: phoneNumber,
        type: models.OrderType.simCard,
        status: models.OrderStatus.pending,
        items: orderItems,
        subtotal: subtotal,
        tax: tax,
        shipping: shipping,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
        notes: notes,
        deliveryAddress: deliveryAddress,
      );

      // Save to Firestore
      await orderRef.set(order.toJson());

      // Reserve SIM cards
      for (final cartItem in cartItems) {
        await _reserveSimCard(cartItem.simId, userId);
      }

      return orderRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<models.Order>> getUserOrders(String userId) async {
    try {
      final snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => models.Order.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  Future<models.Order?> getOrderById(String orderId) async {
    try {
      final doc = await _db.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return models.Order.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    models.OrderStatus status,
  ) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
        if (status == models.OrderStatus.delivered)
          'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final order = await getOrderById(orderId);
      if (order == null) {
        throw Exception('Order not found');
      }

      // Update order status
      await updateOrderStatus(orderId, models.OrderStatus.cancelled);

      // Release reserved SIM cards
      for (final item in order.items) {
        await _releaseSimCard(item.productId);
      }
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  Future<void> _reserveSimCard(String simId, String userId) async {
    try {
      await _db.collection('sim_cards').doc(simId).update({
        'status': 'reserved',
        'userId': userId,
        'reservedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Log error but don't throw to avoid breaking the order creation
      print('Failed to reserve SIM card $simId: $e');
    }
  }

  Future<void> _releaseSimCard(String simId) async {
    try {
      await _db.collection('sim_cards').doc(simId).update({
        'status': 'available',
        'userId': null,
        'reservedAt': null,
      });
    } catch (e) {
      // Log error but don't throw
      print('Failed to release SIM card $simId: $e');
    }
  }

  // Statistics for admin
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final orders = await _db.collection('orders').get();

      int totalOrders = orders.docs.length;
      int pendingOrders = 0;
      int completedOrders = 0;
      int cancelledOrders = 0;
      double totalRevenue = 0;

      for (final doc in orders.docs) {
        final order = models.Order.fromJson(doc.data());

        switch (order.status) {
          case models.OrderStatus.pending:
          case models.OrderStatus.confirmed:
          case models.OrderStatus.processing:
          case models.OrderStatus.shipped:
            pendingOrders++;
            break;
          case models.OrderStatus.delivered:
            completedOrders++;
            totalRevenue += order.totalAmount;
            break;
          case models.OrderStatus.cancelled:
          case models.OrderStatus.rejected:
            cancelledOrders++;
            break;
        }
      }

      return {
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'completedOrders': completedOrders,
        'cancelledOrders': cancelledOrders,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      throw Exception('Failed to get order statistics: $e');
    }
  }
}
