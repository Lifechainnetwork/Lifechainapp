import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class SendAssetScreen extends StatelessWidget {
  const SendAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Asset'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transfer internal within the Lifechain Network',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildTransferOption(
              context,
              'Transfer internal within the Lifechain Network',
              Icons.swap_horiz,
            ),
            const SizedBox(height: 12),
            _buildTransferOption(
              context,
              'Deposit to Lifechain Gaming',
              Icons.sports_esports,
            ),
            const SizedBox(height: 12),
            _buildTransferOption(
              context,
              'Deposit to Lifechain Prediction',
              Icons.trending_up,
            ),
            const SizedBox(height: 12),
            _buildTransferOption(
              context,
              'Deposit to Lifechain P2P',
              Icons.people,
            ),
            const SizedBox(height: 12),
            _buildTransferOption(
              context,
              'Deposit to Lifechain Launchpad',
              Icons.rocket_launch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferOption(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return CustomCard(
      onTap: () {},
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }
}
