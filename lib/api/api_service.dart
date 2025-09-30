import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
  static const String _apiKey =
      "a2a72579-1559-4a5e-a04b-a867cce2b18e"; // replace with your API key

  /// Fetch coins with optional pagination and sorting
  static Future<List<dynamic>> fetchCoins({
    int start = 1, // starting rank
    int limit = 5000, // number of coins (max 5000)
    String sort = "market_cap", // sort by: market_cap, volume_24h, etc.
  }) async {
    final uri = Uri.parse(
      "$_baseUrl?start=$start&limit=$limit&sort=$sort&cryptocurrency_type=all",
    );

    final response = await http.get(
      uri,
      headers: {"X-CMC_PRO_API_KEY": _apiKey, "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["data"];
    } else {
      throw Exception("Failed to load coins: ${response.reasonPhrase}");
    }
  }
}
