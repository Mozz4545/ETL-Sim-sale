import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/sim_card_model.dart';
import '../services/sim_service.dart';

// Service Provider
final simServiceProvider = Provider<SimService>((ref) => SimService());

// SIM Cards List Provider
final simCardsProvider = FutureProvider<List<SimCard>>((ref) async {
  final service = ref.read(simServiceProvider);
  return service.getSimCards();
});

// Data Packages Provider
final dataPackagesProvider = FutureProvider<List<DataPackage>>((ref) async {
  final service = ref.read(simServiceProvider);
  return service.getDataPackages();
});

// Filter States
final simTypeFilterProvider = StateProvider<SimCardType?>((ref) => null);
final priceRangeFilterProvider = StateProvider<PriceRange?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered SIM Cards Provider
final filteredSimCardsProvider = Provider<AsyncValue<List<SimCard>>>((ref) {
  final simCardsAsync = ref.watch(simCardsProvider);
  final typeFilter = ref.watch(simTypeFilterProvider);
  final priceFilter = ref.watch(priceRangeFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return simCardsAsync.when(
    data: (simCards) {
      var filtered = simCards.where((sim) {
        // Type filter
        if (typeFilter != null && sim.type != typeFilter) {
          return false;
        }

        // Price filter
        if (priceFilter != null) {
          if (sim.price < priceFilter.min || sim.price > priceFilter.max) {
            return false;
          }
        }

        // Search query
        if (searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          if (!sim.phoneNumber.toLowerCase().contains(query) &&
              !(sim.packageName ?? '').toLowerCase().contains(query)) {
            return false;
          }
        }

        return true;
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Shopping Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Cart Models
class CartItem {
  final String id;
  final String simId;
  final String simNumber;
  final double price;
  final String packageName;
  final int quantity;

  CartItem({
    required this.id,
    required this.simId,
    required this.simNumber,
    required this.price,
    required this.packageName,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? simId,
    String? simNumber,
    double? price,
    String? packageName,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      simId: simId ?? this.simId,
      simNumber: simNumber ?? this.simNumber,
      price: price ?? this.price,
      packageName: packageName ?? this.packageName,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;
}

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(SimCard simCard) {
    final existingIndex = state.indexWhere((item) => item.simId == simCard.id);

    if (existingIndex >= 0) {
      // Update quantity if item already exists
      final existing = state[existingIndex];
      state = [
        ...state.sublist(0, existingIndex),
        existing.copyWith(quantity: existing.quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        simId: simCard.id,
        simNumber: simCard.phoneNumber,
        price: simCard.price,
        packageName: simCard.packageName ?? 'ແພັກເກດພື້ນຖານ',
      );
      state = [...state, newItem];
    }
  }

  void removeFromCart(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final index = state.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: quantity),
        ...state.sublist(index + 1),
      ];
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}
