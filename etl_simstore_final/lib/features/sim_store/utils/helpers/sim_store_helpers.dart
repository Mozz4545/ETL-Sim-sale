import '../constants/sim_store_constants.dart';

// Basic models for helper functions
enum SimCardType { prepaid, postpaid, tourist, business }

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});
}

class SimCard {
  final String id;
  final String phoneNumber;
  final String? packageName;
  final double price;
  final SimCardType type;

  SimCard({
    required this.id,
    required this.phoneNumber,
    this.packageName,
    required this.price,
    required this.type,
  });
}

class SimStoreHelpers {
  /// Format price to Lao Kip currency
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ກີບ';
  }

  /// Parse wanted/unwanted numbers from string
  static List<String> parseNumbers(String numbersString) {
    if (numbersString.isEmpty) return [];

    return numbersString
        .split(SimStoreConstants.wantedNumbersSeparator)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Check if phone number contains wanted numbers
  static bool containsWantedNumbers(
    String phoneNumber,
    List<String> wantedNumbers,
  ) {
    if (wantedNumbers.isEmpty) return true;

    for (String wanted in wantedNumbers) {
      if (phoneNumber.contains(wanted)) {
        return true;
      }
    }
    return false;
  }

  /// Check if phone number contains unwanted numbers
  static bool containsUnwantedNumbers(
    String phoneNumber,
    List<String> unwantedNumbers,
  ) {
    if (unwantedNumbers.isEmpty) return false;

    for (String unwanted in unwantedNumbers) {
      if (phoneNumber.contains(unwanted)) {
        return true;
      }
    }
    return false;
  }

  /// Filter SIM cards based on criteria
  static List<SimCard> filterSimCards({
    required List<SimCard> simCards,
    SimCardType? typeFilter,
    PriceRange? priceFilter,
    String searchQuery = '',
    List<String> wantedNumbers = const [],
    List<String> unwantedNumbers = const [],
  }) {
    return simCards.where((sim) {
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

      // Wanted numbers filter
      if (!containsWantedNumbers(sim.phoneNumber, wantedNumbers)) {
        return false;
      }

      // Unwanted numbers filter
      if (containsUnwantedNumbers(sim.phoneNumber, unwantedNumbers)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get SIM card type display name
  static String getSimTypeDisplayName(SimCardType type) {
    switch (type) {
      case SimCardType.prepaid:
        return SimStoreStrings.prepaidTab;
      case SimCardType.postpaid:
        return SimStoreStrings.postpaidTab;
      case SimCardType.tourist:
        return SimStoreStrings.touristTab;
      case SimCardType.business:
        return SimStoreStrings.businessTab;
    }
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Lao phone number validation (simple check)
    final phoneRegex = RegExp(r'^(020|021|030)\d{7,8}$');
    return phoneRegex.hasMatch(phoneNumber.replaceAll(' ', ''));
  }

  /// Generate unique cart item ID
  static String generateCartItemId(String simId, String packageId) {
    return '${simId}_$packageId';
  }
}
