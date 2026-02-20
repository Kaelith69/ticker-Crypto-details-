import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const Duck(),
    );
  }
}

class Duck extends StatefulWidget {
  const Duck({super.key});

  @override
  State<Duck> createState() => _DuckState();
}

class _DuckState extends State<Duck> {
  static const ktext1 = TextStyle(
    color: Color(0xFFFFFFFF),
    letterSpacing: 20,
    fontSize: 30,
    fontWeight: FontWeight.w200,
    shadows: [
      Shadow(color: Colors.black, offset: Offset(1.5, 1.5), blurRadius: 5.5)
    ],
  );

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic> coinData = {};
  final List<String> coinOptions = [
    'bitcoin',
    'ethereum',
    'litecoin',
    'dogecoin',
    'tether',
    'pepe',
    'cardano',
    'ripple',
    'polkadot',
    'chainlink',
    'binancecoin',
    'stellar',
  ];

  String selectedCoin = 'bitcoin';

  @override
  void initState() {
    super.initState();
    fetchCoinMarketData(selectedCoin);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchCoinMarketData(String coinId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$coinId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          setState(() {
            coinData = data[0] as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            coinData = {};
            errorMessage = 'No data found for "$coinId".';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          coinData = {};
          errorMessage = 'Request failed (HTTP ${response.statusCode}).';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        coinData = {};
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  /// Formats a large number as a human-readable string (e.g. \$1.23T, \$456.7B).
  String _formatMarketCap(num? value) {
    if (value == null) return 'N/A';
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(2)}K';
    return '\$$value';
  }

  /// Builds one ring of the concentric-border card decoration.
  Widget _buildRing({
    required double radius,
    required double padding,
    required Widget child,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            spreadRadius: 8,
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(padding),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 6,
        centerTitle: true,
        title: const Text(
          'Nyx',
          style: ktext1,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(150)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildRing(
            context: context,
            radius: 90,
            padding: 9,
            child: _buildRing(
              context: context,
              radius: 85,
              padding: 10,
              child: _buildRing(
                context: context,
                radius: 80,
                padding: 9,
                child: _buildRing(
                  context: context,
                  radius: 75,
                  padding: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 38.0, vertical: 20),
                        child: SizedBox(
                          height: 160,
                          child: CupertinoPicker(
                            scrollController: _scrollController,
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                selectedCoin = coinOptions[index];
                              });
                            },
                            children: coinOptions.map((coin) {
                              return Text(
                                coin,
                                style: TextStyle(
                                  fontSize: 28.0,
                                  color: textColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          padding: const EdgeInsets.all(6.0),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => fetchCoinMarketData(selectedCoin),
                            style: ElevatedButton.styleFrom(
                              elevation: 15,
                              shadowColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    'Show Coin Data',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(.5, .5),
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (coinData.isNotEmpty) ...[
                        if (coinData['image'] != null)
                          Image.network(
                            coinData['image'] as String,
                            height: 100,
                          ),
                        const SizedBox(height: 20),
                        Text(
                          'Name: ${coinData['name']}',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        Text(
                          'Symbol: ${(coinData['symbol'] as String).toUpperCase()}',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        Text(
                          'Current Price: \$${coinData['current_price']}',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                        Builder(builder: (context) {
                          final change = coinData[
                              'price_change_percentage_24h'] as num?;
                          return Text(
                            '24h Change: ${change?.toStringAsFixed(2) ?? 'N/A'}%',
                            style: TextStyle(
                              fontSize: 16,
                              color: (change ?? 0) >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        }),
                        Text(
                          'Market Cap: ${_formatMarketCap(coinData['market_cap'] as num?)}',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
