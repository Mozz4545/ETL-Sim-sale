class SimStoreValidators {
  /// Validate phone number format for Lao numbers
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນເບີໂທ';
    }

    // Remove spaces and special characters
    final cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Check Lao phone number format
    if (!RegExp(r'^(020|021|030)\d{7,8}$').hasMatch(cleanNumber)) {
      return 'ຮູບແບບເບີໂທບໍ່ຖືກຕ້ອງ (ຕົວຢ່າງ: 020 XXXX XXXX)';
    }

    return null;
  }

  /// Validate price input
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນລາຄາ';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'ລາຄາຕ້ອງເປັນຕົວເລກ';
    }

    if (price < 0) {
      return 'ລາຄາຕ້ອງບໍ່ນ້ອຍກວ່າ 0';
    }

    if (price > 10000000) {
      return 'ລາຄາສູງເກິນໄປ';
    }

    return null;
  }

  /// Validate quantity input
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນຈຳນວນ';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'ຈຳນວນຕ້ອງເປັນຕົວເລກ';
    }

    if (quantity < 1) {
      return 'ຈຳນວນຕ້ອງບໍ່ນ້ອຍກວ່າ 1';
    }

    if (quantity > 100) {
      return 'ຈຳນວນບໍ່ເກີນ 100';
    }

    return null;
  }

  /// Validate filter numbers input
  static String? validateFilterNumbers(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Check if contains only numbers, commas, and spaces
    if (!RegExp(r'^[0-9,\s]+$').hasMatch(value)) {
      return 'ໃຊ້ໄດ້ແຕ່ຕົວເລກ, ເຄື່ອງໝາຍຈຸດ (,) ແລະ ຊ່ອງວ່າງເທົ່ານັ້ນ';
    }

    return null;
  }

  /// Validate search query
  static String? validateSearchQuery(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    if (value.length < 2) {
      return 'ຄຳຄົ້ນຫາຕ້ອງມີຢ່າງໜ້ອຍ 2 ຕົວອັກສອນ';
    }

    if (value.length > 50) {
      return 'ຄຳຄົ້ນຫາຍາວເກິນໄປ';
    }

    return null;
  }

  /// Validate package name
  static String? validatePackageName(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນຊື່ແພັກເກດ';
    }

    if (value.length < 3) {
      return 'ຊື່ແພັກເກດຕ້ອງມີຢ່າງໜ້ອຍ 3 ຕົວອັກສອນ';
    }

    if (value.length > 100) {
      return 'ຊື່ແພັກເກດຍາວເກິນໄປ';
    }

    return null;
  }

  /// Check if input contains only allowed characters
  static bool isValidInput(String input, {bool allowSpecialChars = false}) {
    if (allowSpecialChars) {
      return RegExp(r'^[a-zA-Z0-9\s\u0E80-\u0EFF,.-]+$').hasMatch(input);
    } else {
      return RegExp(r'^[a-zA-Z0-9\s\u0E80-\u0EFF]+$').hasMatch(input);
    }
  }
}
