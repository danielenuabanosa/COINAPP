import 'package:flutter/material.dart';
import '../models/coin.dart';
import '../utils/formatters.dart';

class CoinDetailScreen extends StatelessWidget {
  final Coin coin;
  const CoinDetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final isUp = coin.percentChange24h >= 0;

    return Scaffold(
      appBar: AppBar(title: Text(coin.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Text(
                  coin.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              coin.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${coin.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isUp ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(
                  "24h Change",
                  "${coin.percentChange24h.toStringAsFixed(2)}%",
                ),
                _buildStat(
                  "Market Cap",
                  Formatters.formatCurrency(coin.marketCap),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(
                  "Volume (24h)",
                  Formatters.formatCurrency(coin.volume24h),
                ),
                _buildStat("Symbol", coin.symbol),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
