import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../models/referral.dart';

class ReferralScreen extends StatelessWidget {
  final ReferralData referralData;

  const ReferralScreen({super.key, required this.referralData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR FRIENDS'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildReferralStats(),
            const SizedBox(height: 24),
            _buildReferralMessage(),
            const SizedBox(height: 24),
            _buildQRCode(context),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralStats() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    '${referralData.directReferrals}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.people,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Direct Referral',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          Container(width: 1, height: 50, color: AppTheme.dividerColor),
          Column(
            children: [
              Text(
                '${referralData.indirectReferrals}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Indirect Referral',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReferralMessage() {
    return const Column(
      children: [
        Text(
          'Maximize your data network.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          'More nodes, faster mining.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: 16),
        Text(
          'Expand your network now',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQRCode(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: 'https://lifechain.app/referral/${referralData.referralCode}',
            version: QrVersions.auto,
            size: 180,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              referralData.referralCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.copy,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: referralData.referralCode),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Referral code copied to clipboard'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Join Lifechain',
            onPressed: () {},
            type: ButtonType.outline,
            icon: Icons.people,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: 'Invite friends',
            onPressed: () {},
            type: ButtonType.primary,
            icon: Icons.send,
          ),
        ),
      ],
    );
  }
}
