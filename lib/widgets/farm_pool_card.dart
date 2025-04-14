import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/farm_pool.dart';
import '../widgets/custom_card.dart';

class FarmPoolCard extends StatelessWidget {
  final FarmPool pool;
  final bool isEnded;
  final VoidCallback? onStake;
  final VoidCallback? onUnstake;
  final VoidCallback? onHarvest;
  final VoidCallback? onDetails;

  const FarmPoolCard({
    super.key,
    required this.pool,
    this.isEnded = false,
    this.onStake,
    this.onUnstake,
    this.onHarvest,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildStats(),
          if (pool.userStakedAmount > 0) ...[
            const SizedBox(height: 16),
            _buildUserPosition(),
          ],
          const SizedBox(height: 16),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildTokenPairIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pool.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Earn ${pool.rewardToken}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (isEnded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'ENDED',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${pool.apy.toStringAsFixed(1)}% APY',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTokenPairIcon() {
    final tokens = pool.lpToken.split('-');
    final token1 = tokens[0];
    final token2 = tokens.length > 1 ? tokens[1] : '';

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: _buildTokenIcon(token1),
          ),
          if (token2.isNotEmpty)
            Positioned(
              right: 0,
              child: _buildTokenIcon(token2),
            ),
        ],
      ),
    );
  }

  Widget _buildTokenIcon(String symbol) {
    Color iconColor;
    
    switch (symbol.toUpperCase()) {
      case 'LCN':
        iconColor = AppTheme.primaryColor;
        break;
      case 'ETH':
        iconColor = Colors.blue;
        break;
      case 'USDT':
        iconColor = Colors.green;
        break;
      case 'BNB':
        iconColor = Colors.amber;
        break;
      default:
        iconColor = Colors.grey;
    }
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: iconColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          symbol.substring(0, 1),
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('TVL', '\$${_formatNumber(pool.tvl)}'),
        _buildStatItem('Reward Token', pool.rewardToken),
        _buildStatItem('Stakers', pool.totalStakers.toString()),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildUserPosition() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Position',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPositionItem(
                'Staked',
                '${pool.userStakedAmount.toStringAsFixed(2)} ${pool.lpToken}',
                '\$${pool.userStakedValue.toStringAsFixed(2)}',
              ),
              _buildPositionItem(
                'Rewards',
                '${pool.userRewards.toStringAsFixed(2)} ${pool.rewardToken}',
                '\$${pool.userRewardsValue.toStringAsFixed(2)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionItem(String label, String amount, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        if (!isEnded && onStake != null)
          Expanded(
            child: ElevatedButton(
              onPressed: onStake,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Stake'),
            ),
          ),
        if (onUnstake != null) ...[
          if (!isEnded && onStake != null) const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onUnstake,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              child: const Text('Unstake'),
            ),
          ),
        ],
        if (onHarvest != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onHarvest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Harvest'),
            ),
          ),
        ],
        if (onDetails != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDetails,
            icon: const Icon(
              Icons.info_outline,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
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
}
