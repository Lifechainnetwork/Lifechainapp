class LiquidityPool {
  final String id;
  final String name;
  final String token0Symbol;
  final String token1Symbol;
  final double token0Amount;
  final double token1Amount;
  final double totalLiquidity;
  final double apr;
  final double userLpTokens;
  final double totalLpTokens;
  final double feePercent;
  final double volume24h;
  final bool isActive;

  const LiquidityPool({
    required this.id,
    required this.name,
    required this.token0Symbol,
    required this.token1Symbol,
    required this.token0Amount,
    required this.token1Amount,
    required this.totalLiquidity,
    required this.apr,
    required this.userLpTokens,
    required this.totalLpTokens,
    required this.feePercent,
    required this.volume24h,
    required this.isActive,
  });

  // Get user's share of the pool in percentage
  double get userSharePercent {
    if (totalLpTokens == 0) return 0;
    return (userLpTokens / totalLpTokens) * 100;
  }

  // Get user's token amounts based on their share
  double get userToken0Amount {
    return (userSharePercent / 100) * token0Amount;
  }

  double get userToken1Amount {
    return (userSharePercent / 100) * token1Amount;
  }

  // Get the price ratio between the two tokens
  double get token0PerToken1 {
    if (token1Amount == 0) return 0;
    return token0Amount / token1Amount;
  }

  double get token1PerToken0 {
    if (token0Amount == 0) return 0;
    return token1Amount / token0Amount;
  }

  // Get demo data for the UI
  static List<LiquidityPool> getDemoData() {
    return [
      const LiquidityPool(
        id: 'lcn-eth',
        name: 'LCN-ETH',
        token0Symbol: 'LCN',
        token1Symbol: 'ETH',
        token0Amount: 1250000,
        token1Amount: 500,
        totalLiquidity: 2500000,
        apr: 24.5,
        userLpTokens: 100,
        totalLpTokens: 10000,
        feePercent: 0.3,
        volume24h: 150000,
        isActive: true,
      ),
      const LiquidityPool(
        id: 'lcn-usdt',
        name: 'LCN-USDT',
        token0Symbol: 'LCN',
        token1Symbol: 'USDT',
        token0Amount: 2000000,
        token1Amount: 2000000,
        totalLiquidity: 4000000,
        apr: 18.2,
        userLpTokens: 0,
        totalLpTokens: 20000,
        feePercent: 0.3,
        volume24h: 250000,
        isActive: true,
      ),
      const LiquidityPool(
        id: 'lcn-bnb',
        name: 'LCN-BNB',
        token0Symbol: 'LCN',
        token1Symbol: 'BNB',
        token0Amount: 750000,
        token1Amount: 2500,
        totalLiquidity: 1500000,
        apr: 22.8,
        userLpTokens: 50,
        totalLpTokens: 5000,
        feePercent: 0.3,
        volume24h: 85000,
        isActive: true,
      ),
      const LiquidityPool(
        id: 'eth-usdt',
        name: 'ETH-USDT',
        token0Symbol: 'ETH',
        token1Symbol: 'USDT',
        token0Amount: 1000,
        token1Amount: 2500000,
        totalLiquidity: 5000000,
        apr: 15.6,
        userLpTokens: 0,
        totalLpTokens: 25000,
        feePercent: 0.3,
        volume24h: 450000,
        isActive: true,
      ),
    ];
  }
}
