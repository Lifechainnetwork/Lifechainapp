class TokenPair {
  final String id;
  final String baseToken;
  final String quoteToken;
  final double price;
  final double priceChange24h;
  final double volume24h;
  final double liquidity;
  final int transactions24h;
  final List<PricePoint> priceHistory;

  const TokenPair({
    required this.id,
    required this.baseToken,
    required this.quoteToken,
    required this.price,
    required this.priceChange24h,
    required this.volume24h,
    required this.liquidity,
    required this.transactions24h,
    required this.priceHistory,
  });

  String get pairName => '$baseToken/$quoteToken';

  static List<TokenPair> getDemoData() {
    return [
      TokenPair(
        id: 'lcn-eth',
        baseToken: 'LCN',
        quoteToken: 'ETH',
        price: 0.0005,
        priceChange24h: 3.2,
        volume24h: 150000,
        liquidity: 2500000,
        transactions24h: 1250,
        priceHistory: _generatePriceHistory(0.0005, 3.2),
      ),
      TokenPair(
        id: 'lcn-usdt',
        baseToken: 'LCN',
        quoteToken: 'USDT',
        price: 1.25,
        priceChange24h: 2.8,
        volume24h: 250000,
        liquidity: 4000000,
        transactions24h: 1850,
        priceHistory: _generatePriceHistory(1.25, 2.8),
      ),
      TokenPair(
        id: 'lcn-bnb',
        baseToken: 'LCN',
        quoteToken: 'BNB',
        price: 0.004,
        priceChange24h: -1.5,
        volume24h: 85000,
        liquidity: 1500000,
        transactions24h: 750,
        priceHistory: _generatePriceHistory(0.004, -1.5),
      ),
      TokenPair(
        id: 'eth-usdt',
        baseToken: 'ETH',
        quoteToken: 'USDT',
        price: 2500,
        priceChange24h: 1.2,
        volume24h: 450000,
        liquidity: 5000000,
        transactions24h: 2200,
        priceHistory: _generatePriceHistory(2500, 1.2),
      ),
      TokenPair(
        id: 'bnb-usdt',
        baseToken: 'BNB',
        quoteToken: 'USDT',
        price: 320,
        priceChange24h: -0.8,
        volume24h: 320000,
        liquidity: 3500000,
        transactions24h: 1800,
        priceHistory: _generatePriceHistory(320, -0.8),
      ),
    ];
  }

  static List<PricePoint> _generatePriceHistory(double currentPrice, double priceChange24h) {
    final List<PricePoint> history = [];
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch % 1000 / 1000;
    
    // Generate 24 hourly price points
    for (int i = 24; i >= 0; i--) {
      final time = now.subtract(Duration(hours: i));
      
      // Calculate a price that trends toward the current price
      final progress = (24 - i) / 24;
      final volatility = 0.02 * (random + 0.5); // Random volatility between 1-3%
      final trendFactor = priceChange24h > 0 ? progress : (1 - progress);
      final priceOffset = (priceChange24h.abs() / 100) * currentPrice * trendFactor;
      
      double price;
      if (priceChange24h > 0) {
        price = currentPrice - priceOffset;
      } else {
        price = currentPrice + priceOffset;
      }
      
      // Add some random noise
      final noise = (random - 0.5) * volatility * price;
      price += noise;
      
      history.add(PricePoint(time, price));
    }
    
    return history;
  }
}

class PricePoint {
  final DateTime time;
  final double price;

  const PricePoint(this.time, this.price);
}
