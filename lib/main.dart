import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../api/api_service.dart';
import '../models/coin.dart';
import 'screens/coin_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinMarketCap App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Coin>> coins = Future.value([]);
  List<Coin> filteredCoins = [];
  String query = "";
  Timer? autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _loadCoins();

    // Auto-refresh every 60s
    autoRefreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _loadCoins();
    });
  }

  @override
  void dispose() {
    autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCoins() async {
    try {
      final data = await ApiService.fetchCoins();
      final list = data.map<Coin>((json) => Coin.fromJson(json)).toList();

      setState(() {
        coins = Future.value(list); // keep for FutureBuilder
        filteredCoins = list;
      });
    } catch (e) {
      setState(() {
        coins = Future.error(e.toString());
      });
    }
  }

  void _filterCoins(String keyword) {
    setState(() {
      query = keyword.toLowerCase();
      coins.then((list) {
        setState(() {
          filteredCoins = list
              .where(
                (coin) =>
                    coin.name.toLowerCase().contains(query) ||
                    coin.symbol.toLowerCase().contains(query),
              )
              .toList();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadCoins();
        },
        child: CustomScrollView(
          slivers: [
            // 🔹 App Bar with Gradient
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 100,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "CoinMarketCap",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: _filterCoins,
                  decoration: InputDecoration(
                    hintText: "Search coin (BTC, ETH...)",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 Coins List
            SliverFillRemaining(
              child: FutureBuilder<List<Coin>>(
                future: coins,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No coins found"));
                  }

                  return ListView.builder(
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      final isUp = coin.percentChange24h >= 0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoinDetailScreen(coin: coin),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              coin.symbol,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            coin.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "\$${coin.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isUp ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isUp ? Icons.trending_up : Icons.trending_down,
                                color: isUp ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              Text(
                                "${coin.percentChange24h.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  color: isUp ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
