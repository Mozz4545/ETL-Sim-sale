class SimStoreConstants {
  // Collection names
  static const String simCardsCollection = 'sim_cards';
  static const String dataPackagesCollection = 'data_packages';
  static const String ordersCollection = 'orders';

  // SIM Card Types
  static const String prepaidType = 'prepaid';
  static const String postpaidType = 'postpaid';
  static const String touristType = 'tourist';
  static const String businessType = 'business';

  // Price ranges
  static const double minPrice = 0;
  static const double maxPrice = 1000000;

  // UI Constants
  static const double cardBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;

  // Filter constants
  static const String allFilter = 'all';
  static const String wantedNumbersSeparator = ',';

  // Error messages
  static const String errorLoadingData = 'Error loading SIM cards data';
  static const String errorAddingToCart = 'Error adding item to cart';
  static const String errorEmptyCart = 'Cart is empty';
}

class SimStoreStrings {
  // Page titles
  static const String simStoreTitle = 'ອີທີແອວ ຊິມສະຕໍ';
  static const String cartTitle = 'ກະຕ່າ';
  static const String simDetailTitle = 'ລາຍລະອຽດຊິມກາດ';

  // Buttons
  static const String addToCart = 'ເພີ່ມໃສ່ກະຕ່າ';
  static const String buyNow = 'ຊື້ດຽວນີ້';
  static const String clearFilters = 'ລຶບຕົວກອງທັງໝົດ';
  static const String applyFilters = 'ໃຊ້ຕົວກອງ';

  // Filter labels
  static const String searchHint = 'ຄົ້ນຫາເບີໂທ...';
  static const String wantedNumbersHint = 'ເບີທີ່ຕ້ອງການ (ເຊັ່ນ: 888, 999)';
  static const String unwantedNumbersHint = 'ເບີທີ່ບໍ່ຕ້ອງການ (ເຊັ່ນ: 4, 666)';
  static const String priceFilter = 'ລາຄາ:';
  static const String selectPrice = 'ເລືອກລາຄາ';

  // Tab titles
  static const String allTab = 'ທັງໝົດ';
  static const String prepaidTab = 'ເບີໂທລະສັບມືຖື(ແບບຕື່ມເງິນ)';
  static const String postpaidTab = 'ເບີໂທລະສັບມືຖື(ແບບລາຍເດືອນ)';
  static const String touristTab = 'ຊິມລວມແພັກເກັດສຳຫລັບນັກທ່ອງທ່ຽວ';
  static const String businessTab = 'ເບີໂທລະສັບມືຖືສຳລັບທຸລະກິດ';
}
