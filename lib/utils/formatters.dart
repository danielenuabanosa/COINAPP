import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    final NumberFormat formatter = NumberFormat.compactCurrency(
      symbol: "\$",
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String formatNumber(double value) {
    final NumberFormat formatter = NumberFormat.compact();
    return formatter.format(value);
  }
}
