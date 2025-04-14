import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../models/farm_pool.dart';
import '../widgets/farm_pool_card.dart';

class YieldFarmingScreen extends StatefulWidget {
  const YieldFarmingScreen({super.key});

  @override
  State<YieldFarmingScreen> createState() => _YieldFarmingScreenState();
}

class _YieldFarmingScreenState extends State<YieldFarmingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<FarmPool> _farmPools = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFarmPools();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadFarmPools() async {
    // Simulate loading from API
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _farmPools = FarmPool.getDemoData();
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Yield Farming'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Active Farms'),
            Tab(text: 'My Farms'),
            Tab(text: 'Ended'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveFarmsTab(),
                _buildMyFarmsTab(),
                _buildEndedFarmsTab(),
              ],
            ),
    );
  }
  
  Widget _buildActiveFarmsTab() {
    final activePools = _farmPools.where((pool) => !pool.isEnded).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFarmingHeader(activePools),
          const SizedBox(height: 24),
          ...activePools.map((pool) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FarmPoolCard(
              pool: pool,
              onStake: () => _showStakeDialog(context, pool),
              onUnstake: pool.userStakedAmount > 0
                  ? () => _showUnstakeDialog(context, pool)
                  : () {},
              onHarvest: pool.userRewards > 0
                  ? () => _showHarvestDialog(context, pool)
                  : () {},
              onDetails: () => _showPoolDetailsDialog(context, pool),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildMyFarmsTab() {
    final userPools = _farmPools.where((pool) => pool.userStakedAmount > 0).toList();
    
    if (userPools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Active Farms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stake LP tokens to earn rewards',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _tabController.animateTo(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Active Farms',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserFarmingHeader(userPools),
          const SizedBox(height: 24),
          ...userPools.map((pool) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FarmPoolCard(
              pool: pool,
              onStake: () => _showStakeDialog(context, pool),
              onUnstake: () => _showUnstakeDialog(context, pool),
              onHarvest: pool.userRewards > 0
                  ? () => _showHarvestDialog(context, pool)
                  : () {},
              onDetails: () => _showPoolDetailsDialog(context, pool),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildEndedFarmsTab() {
    final endedPools = _farmPools.where((pool) => pool.isEnded).toList();
    
    if (endedPools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Ended Farms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ended farms will appear here',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...endedPools.map((pool) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FarmPoolCard(
              pool: pool,
              isEnded: true,
              onUnstake: pool.userStakedAmount > 0
                  ? () => _showUnstakeDialog(context, pool)
                  : () {},
              onHarvest: pool.userRewards > 0
                  ? () => _showHarvestDialog(context, pool)
                  : () {},
              onDetails: () => _showPoolDetailsDialog(context, pool),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildFarmingHeader(List<FarmPool> pools) {
    // Calculate total TVL across all pools
    final totalTVL = pools.fold(0.0, (sum, pool) => sum + pool.tvl);
    
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yield Farming',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stake LP tokens to earn additional rewards',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.dividerColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox('Total Value Locked', '\$${_formatNumber(totalTVL)}'),
              _buildInfoBox('Active Farms', pools.length.toString()),
              _buildInfoBox('Avg. APY', '${_calculateAverageAPY(pools).toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserFarmingHeader(List<FarmPool> userPools) {
    // Calculate user's total staked value
    final totalUserStaked = userPools.fold(
      0.0,
      (sum, pool) => sum + pool.userStakedAmount * pool.lpTokenPrice,
    );
    
    // Calculate user's total pending rewards
    final totalUserRewards = userPools.fold(
      0.0,
      (sum, pool) => sum + pool.userRewards * pool.rewardTokenPrice,
    );
    
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Farms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.dividerColor),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoBox('Staked Value', '\$${_formatNumber(totalUserStaked)}'),
              _buildInfoBox('Active Positions', userPools.length.toString()),
              _buildInfoBox('Pending Rewards', '\$${_formatNumber(totalUserRewards)}'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  double _calculateAverageAPY(List<FarmPool> pools) {
    if (pools.isEmpty) return 0;
    
    // Calculate weighted average APY based on pool TVL
    double weightedAPYSum = 0;
    double totalTVL = 0;
    
    for (final pool in pools) {
      weightedAPYSum += pool.apy * pool.tvl;
      totalTVL += pool.tvl;
    }
    
    return weightedAPYSum / totalTVL;
  }
  
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }
  
  void _showStakeDialog(BuildContext context, FarmPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Stake in ${pool.name}'),
        content: const Text('Stake dialog will be implemented in the next part.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showUnstakeDialog(BuildContext context, FarmPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Unstake from ${pool.name}'),
        content: const Text('Unstake dialog will be implemented in the next part.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showHarvestDialog(BuildContext context, FarmPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Harvest Rewards from ${pool.name}'),
        content: const Text('Harvest dialog will be implemented in the next part.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPoolDetailsDialog(BuildContext context, FarmPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('${pool.name} Details'),
        content: const Text('Pool details dialog will be implemented in the next part.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
