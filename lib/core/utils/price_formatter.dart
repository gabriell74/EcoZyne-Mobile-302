class PriceFormatter {
  /// Format harga dengan menghilangkan .0 jika desimalnya nol
  ///
  /// Contoh:
  /// - 15000.0 -> "15000"
  /// - 15000.5 -> "15000.5"
  /// - 15000.50 -> "15000.5"
  /// - 15000.99 -> "15000.99"
  static String formatPrice(dynamic price) {
    if (price == null) return "0";

    double priceValue;

    if (price is String) {
      priceValue = double.tryParse(price) ?? 0;
    } else if (price is int) {
      priceValue = price.toDouble();
    } else if (price is double) {
      priceValue = price;
    } else {
      priceValue = 0;
    }

    if (priceValue == priceValue.toInt()) {
      return priceValue.toInt().toString();
    }

    return priceValue.toString().replaceAll(RegExp(r'\.?0*$'), '');
  }

  /// Format harga dengan prefix Rp dan separator ribuan
  static String formatPriceWithCurrency(dynamic price) {
    String cleanPrice = formatPrice(price);

    String reversed = cleanPrice.split('').reversed.join('');
    String withSeparator = '';

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0 && reversed[i] != '-') {
        withSeparator += '.';
      }
      withSeparator += reversed[i];
    }

    return 'Rp ${withSeparator.split('').reversed.join('')}';
  }
}

extension PriceExtension on num {
  /// Hapus .0 dari angka
  String get cleanPrice => PriceFormatter.formatPrice(this);

  /// Format dengan Rp dan separator
  String get toCurrency => PriceFormatter.formatPriceWithCurrency(this);
}

extension StringPriceExtension on String {
  /// Hapus .0 dari string angka
  String get cleanPrice => PriceFormatter.formatPrice(this);

  /// Format dengan Rp dan separator
  String get toCurrency => PriceFormatter.formatPriceWithCurrency(this);
}