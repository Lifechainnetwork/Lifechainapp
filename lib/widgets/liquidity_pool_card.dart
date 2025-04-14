import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../models/liquidity_pool.dart';

class LiquidityPoolCard extends StatelessWidget {
  final LiquidityPool pool;
  final VoidCallback? onAddLiquidity;
  final VoidCallback? onRemoveLiquidity;
  final VoidCallback? onDetails;

  const LiquidityPoolCard({
    super.key,
    required this.pool,
    this.onAddLiquidity,
    this.onRemoveLiquidity,
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
          _buildPoolInfo(),
          if (pool.userLpTokens > 0) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppTheme.dividerColor),
            const SizedBox(height: 16),
            _buildUserPosition(),
          ],
          const SizedBox(height: 16),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildTokenIcon(pool.token0Symbol),
            const SizedBox(width: -8),
            _buildTokenIcon(pool.token1Symbol),
            const SizedBox(width: 8),
            Text(
              pool.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'APR: ${pool.apr.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPoolInfo() {
    return Column(
      children: [
        _buildInfoRow(
          'Liquidity',
          '\$${_formatNumber(pool.totalLiquidity)}',
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          'Volume (24h)',
          '\$${_formatNumber(pool.volume24h)}',
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          'Fee',
          '${pool.feePercent}%',
        ),
        const SizedBox(height: 8),
        _buildTokenAmounts(),
      ],
    );
  }

  Widget _buildTokenAmounts() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pool.token0Symbol,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatNumber(pool.token0Amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pool.token1Symbol,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatNumber(pool.token1Amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserPosition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Position',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          'Share of Pool',
          '${pool.userSharePercent.toStringAsFixed(2)}%',
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          'LP Tokens',
          pool.userLpTokens.toString(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pool.token0Symbol,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNumber(pool.userToken0Amount),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pool.token1Symbol,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNumber(pool.userToken1Amount),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onAddLiquidity,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add Liquidity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (pool.userLpTokens > 0) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onRemoveLiquidity,
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
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(width: 12),
        IconButton(
          onPressed: onDetails,
          icon: const Icon(
            Icons.info_outline,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
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
      width: 30,
      height: 30,
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
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else if (number >= 1) {
      return number.toStringAsFixed(2);
    } else {
      return number.toStringAsFixed(6);
    }
  }
}
