import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class TokenStatsCard extends StatelessWidget {
  final String tokenSymbol;
  final double currentPrice;
  final double priceChange24h;
  final double marketCap;
  final double volume24h;
  final int holders;
  final double circulatingSupply;
  final double totalSupply;

  const TokenStatsCard({
    super.key,
    required this.tokenSymbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.marketCap,
    required this.volume24h,
    required this.holders,
    required this.circulatingSupply,
    required this.totalSupply,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$tokenSymbol Stats',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      priceChange24h >= 0
                          ? Colors.green.withValues(alpha: 0.2 * 255)
                          : Colors.red.withValues(alpha: 0.2 * 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      priceChange24h >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: priceChange24h >= 0 ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${priceChange24h.abs().toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: priceChange24h >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Current Price',
            '\$${currentPrice.toStringAsFixed(4)}',
          ),
          _buildStatRow('Market Cap', '\$${_formatLargeNumber(marketCap)}'),
          _buildStatRow('24h Volume', '\$${_formatLargeNumber(volume24h)}'),
          _buildStatRow('Holders', holders.toString()),
          _buildStatRow(
            'Circulating Supply',
            '${_formatLargeNumber(circulatingSupply)} $tokenSymbol',
          ),
          _buildStatRow(
            'Total Supply',
            '${_formatLargeNumber(totalSupply)} $tokenSymbol',
          ),
          const SizedBox(height: 8),
          _buildSupplyProgressBar(circulatingSupply, totalSupply),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplyProgressBar(double circulating, double total) {
    final double percentage = (circulating / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Circulating Supply',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withValues(alpha: 0.5 * 255),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.7 * 255),
                      AppTheme.primaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              '${_formatLargeNumber(circulating)}/${_formatLargeNumber(total)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      ],
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  static TokenStatsCard getDemoData() {
    return const TokenStatsCard(
      tokenSymbol: 'LCN',
      currentPrice: 2.45,
      priceChange24h: 5.67,
      marketCap: 245000000,
      volume24h: 12500000,
      holders: 28750,
      circulatingSupply: 100000000,
      totalSupply: 250000000,
    );
  }
}
