import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class StakingCard extends StatelessWidget {
  final String poolName;
  final String tokenSymbol;
  final double apy;
  final int lockPeriodDays;
  final double minStakeAmount;
  final double totalStaked;
  final double userStaked;
  final double userRewards;
  final bool isActive;

  const StakingCard({
    super.key,
    required this.poolName,
    required this.tokenSymbol,
    required this.apy,
    required this.lockPeriodDays,
    required this.minStakeAmount,
    required this.totalStaked,
    required this.userStaked,
    required this.userRewards,
    required this.isActive,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poolName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(
                            alpha: 0.2 * 255,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tokenSymbol,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? Colors.green.withValues(alpha: 0.2 * 255)
                                  : Colors.grey.withValues(alpha: 0.2 * 255),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2 * 255),
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
                      'APY: ${apy.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Lock Period', '$lockPeriodDays days'),
          _buildInfoRow('Min. Stake', '$minStakeAmount $tokenSymbol'),
          _buildInfoRow('Total Staked', '$totalStaked $tokenSymbol'),
          const Divider(height: 24, color: AppTheme.dividerColor),
          _buildUserStakingInfo(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Stake',
                  onPressed: () {},
                  color: AppTheme.primaryColor,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Unstake',
                  onPressed: () {},
                  color: Colors.transparent,
                  textColor: AppTheme.primaryColor,
                  borderColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Claim Rewards',
            onPressed: () {},
            color:
                userRewards > 0
                    ? Colors.amber
                    : Colors.grey.withValues(alpha: 0.3 * 255),
            textColor: userRewards > 0 ? Colors.black : Colors.grey,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildUserStakingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Staking',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStakingInfoCard(
                'Staked',
                '$userStaked $tokenSymbol',
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStakingInfoCard(
                'Rewards',
                '$userRewards $tokenSymbol',
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStakingInfoCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1 * 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3 * 255), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  static StakingCard getDemoData() {
    return const StakingCard(
      poolName: 'LCN Staking Pool',
      tokenSymbol: 'LCN',
      apy: 12.5,
      lockPeriodDays: 30,
      minStakeAmount: 100,
      totalStaked: 1250000,
      userStaked: 500,
      userRewards: 15.75,
      isActive: true,
    );
  }
}
