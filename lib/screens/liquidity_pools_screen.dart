import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/liquidity_pool.dart';
import '../widgets/liquidity_pool_card.dart';
import '../widgets/custom_card.dart';

class LiquidityPoolsScreen extends StatefulWidget {
  const LiquidityPoolsScreen({super.key});

  @override
  State<LiquidityPoolsScreen> createState() => _LiquidityPoolsScreenState();
}

class _LiquidityPoolsScreenState extends State<LiquidityPoolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LiquidityPool> _pools = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPools();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPools() async {
    // Simulate loading from API
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _pools = LiquidityPool.getDemoData();
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Liquidity Pools'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All Pools'),
            Tab(text: 'My Liquidity'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAllPoolsTab(),
                _buildMyLiquidityTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePoolDialog(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildAllPoolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLiquidityHeader(),
          const SizedBox(height: 24),
          ..._pools.map((pool) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LiquidityPoolCard(
              pool: pool,
              onAddLiquidity: () => _showAddLiquidityDialog(context, pool),
              onRemoveLiquidity: pool.userLpTokens > 0
                  ? () => _showRemoveLiquidityDialog(context, pool)
                  : null,
              onDetails: () => _showPoolDetailsDialog(context, pool),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildMyLiquidityTab() {
    final userPools = _pools.where((pool) => pool.userLpTokens > 0).toList();
    
    if (userPools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Liquidity Positions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add liquidity to a pool to earn fees',
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
                'View All Pools',
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
          _buildUserLiquidityHeader(userPools),
          const SizedBox(height: 24),
          ...userPools.map((pool) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LiquidityPoolCard(
              pool: pool,
              onAddLiquidity: () => _showAddLiquidityDialog(context, pool),
              onRemoveLiquidity: () => _showRemoveLiquidityDialog(context, pool),
              onDetails: () => _showPoolDetailsDialog(context, pool),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildLiquidityHeader() {
    // Calculate total liquidity across all pools
    final totalLiquidity = _pools.fold(0.0, (sum, pool) => sum + pool.totalLiquidity);
    
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liquidity Pools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide liquidity to earn trading fees and APR rewards',
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
              _buildInfoBox('Total Liquidity', '\$${_formatNumber(totalLiquidity)}'),
              _buildInfoBox('Active Pools', _pools.length.toString()),
              _buildInfoBox('Avg. APR', '${_calculateAverageAPR().toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserLiquidityHeader(List<LiquidityPool> userPools) {
    // Calculate user's total liquidity
    final totalUserLiquidity = userPools.fold(
      0.0,
      (sum, pool) => sum + (pool.userSharePercent / 100 * pool.totalLiquidity),
    );
    
    // Calculate average APR weighted by user's liquidity in each pool
    double weightedAPRSum = 0;
    for (final pool in userPools) {
      final userLiquidity = pool.userSharePercent / 100 * pool.totalLiquidity;
      weightedAPRSum += pool.apr * userLiquidity;
    }
    final avgAPR = weightedAPRSum / totalUserLiquidity;
    
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Liquidity',
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
              _buildInfoBox('Your Liquidity', '\$${_formatNumber(totalUserLiquidity)}'),
              _buildInfoBox('Active Positions', userPools.length.toString()),
              _buildInfoBox('Avg. APR', '${avgAPR.toStringAsFixed(1)}%'),
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
  
  double _calculateAverageAPR() {
    if (_pools.isEmpty) return 0;
    
    // Calculate weighted average APR based on pool liquidity
    double weightedAPRSum = 0;
    double totalLiquidity = 0;
    
    for (final pool in _pools) {
      weightedAPRSum += pool.apr * pool.totalLiquidity;
      totalLiquidity += pool.totalLiquidity;
    }
    
    return weightedAPRSum / totalLiquidity;
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
  
  void _showAddLiquidityDialog(BuildContext context, LiquidityPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Add Liquidity to ${pool.name}'),
        content: const Text('Add liquidity dialog will be implemented in the next part.'),
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
  
  void _showRemoveLiquidityDialog(BuildContext context, LiquidityPool pool) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('Remove Liquidity from ${pool.name}'),
        content: const Text('Remove liquidity dialog will be implemented in the next part.'),
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
  
  void _showPoolDetailsDialog(BuildContext context, LiquidityPool pool) {
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
  
  void _showCreatePoolDialog(BuildContext context) {
    // Implementation will be added in the next part
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Create Liquidity Pool'),
        content: const Text('Create pool dialog will be implemented in the next part.'),
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
