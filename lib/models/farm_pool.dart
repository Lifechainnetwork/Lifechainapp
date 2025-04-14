class FarmPool {
  final String id;
  final String name;
  final String lpToken;
  final String rewardToken;
  final double apy;
  final double tvl;
  final double lpTokenPrice;
  final double rewardTokenPrice;
  final double userStakedAmount;
  final double userRewards;
  final bool isEnded;
  final DateTime startDate;
  final DateTime endDate;
  final int totalStakers;
  
  const FarmPool({
    required this.id,
    required this.name,
    required this.lpToken,
    required this.rewardToken,
    required this.apy,
    required this.tvl,
    required this.lpTokenPrice,
    required this.rewardTokenPrice,
    required this.userStakedAmount,
    required this.userRewards,
    required this.isEnded,
    required this.startDate,
    required this.endDate,
    required this.totalStakers,
  });
  
  double get userStakedValue => userStakedAmount * lpTokenPrice;
  double get userRewardsValue => userRewards * rewardTokenPrice;
  
  static List<FarmPool> getDemoData() {
    final now = DateTime.now();
    
    return [
      FarmPool(
        id: 'farm-lcn-eth',
        name: 'LCN-ETH Farm',
        lpToken: 'LCN-ETH LP',
        rewardToken: 'LCN',
        apy: 85.2,
        tvl: 1250000,
        lpTokenPrice: 25.8,
        rewardTokenPrice: 1.25,
        userStakedAmount: 12.5,
        userRewards: 8.75,
        isEnded: false,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 60)),
        totalStakers: 458,
      ),
      FarmPool(
        id: 'farm-lcn-usdt',
        name: 'LCN-USDT Farm',
        lpToken: 'LCN-USDT LP',
        rewardToken: 'LCN',
        apy: 65.8,
        tvl: 2800000,
        lpTokenPrice: 32.4,
        rewardTokenPrice: 1.25,
        userStakedAmount: 0,
        userRewards: 0,
        isEnded: false,
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 75)),
        totalStakers: 752,
      ),
      FarmPool(
        id: 'farm-lcn-bnb',
        name: 'LCN-BNB Farm',
        lpToken: 'LCN-BNB LP',
        rewardToken: 'LCN',
        apy: 92.5,
        tvl: 950000,
        lpTokenPrice: 18.6,
        rewardTokenPrice: 1.25,
        userStakedAmount: 25.8,
        userRewards: 12.4,
        isEnded: false,
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 80)),
        totalStakers: 325,
      ),
      FarmPool(
        id: 'farm-eth-usdt',
        name: 'ETH-USDT Farm',
        lpToken: 'ETH-USDT LP',
        rewardToken: 'LCN',
        apy: 42.3,
        tvl: 3500000,
        lpTokenPrice: 45.2,
        rewardTokenPrice: 1.25,
        userStakedAmount: 0,
        userRewards: 0,
        isEnded: false,
        startDate: now.subtract(const Duration(days: 45)),
        endDate: now.add(const Duration(days: 45)),
        totalStakers: 1250,
      ),
      FarmPool(
        id: 'farm-bnb-usdt',
        name: 'BNB-USDT Farm',
        lpToken: 'BNB-USDT LP',
        rewardToken: 'LCN',
        apy: 38.6,
        tvl: 2250000,
        lpTokenPrice: 38.9,
        rewardTokenPrice: 1.25,
        userStakedAmount: 0,
        userRewards: 0,
        isEnded: false,
        startDate: now.subtract(const Duration(days: 25)),
        endDate: now.add(const Duration(days: 65)),
        totalStakers: 875,
      ),
      FarmPool(
        id: 'farm-lcn-eth-ended',
        name: 'LCN-ETH Farm (Ended)',
        lpToken: 'LCN-ETH LP',
        rewardToken: 'LCN',
        apy: 0,
        tvl: 0,
        lpTokenPrice: 25.8,
        rewardTokenPrice: 1.25,
        userStakedAmount: 5.2,
        userRewards: 1.8,
        isEnded: true,
        startDate: now.subtract(const Duration(days: 120)),
        endDate: now.subtract(const Duration(days: 30)),
        totalStakers: 0,
      ),
    ];
  }
}
