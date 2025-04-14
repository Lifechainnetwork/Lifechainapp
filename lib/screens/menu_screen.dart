import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../screens/settings_screen.dart';
import '../widgets/lcn_logo_widget.dart';
import '../screens/wallet_connect_screen.dart';
import '../screens/liquidity_pools_screen.dart';
import '../screens/swap_screen.dart';
import '../screens/yield_farming_screen.dart';
import '../screens/governance_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserSection(context),
            const SizedBox(height: 24),
            _buildMainMenuSection(context),
            const SizedBox(height: 24),
            _buildBlockchainSection(context),
            const SizedBox(height: 24),
            _buildSecuritySection(context),
            const SizedBox(height: 24),
            _buildDeFiSection(context),
            const SizedBox(height: 24),
            _buildGovernanceSection(context),
            const SizedBox(height: 24),
            _buildSupportSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: LCNLogoWidget(
                size: 44,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User123456',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user123@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Main',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.account_balance,
                title: 'Staking',
                subtitle: 'Stake your LCN tokens to earn rewards',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.swap_horiz,
                title: 'Swap',
                subtitle: 'Exchange tokens at the best rates',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.trending_up,
                title: 'DeFi Dashboard',
                subtitle: 'Manage your DeFi investments',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.analytics,
                title: 'Analytics',
                subtitle: 'View detailed performance metrics',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.account_balance_wallet,
                title: 'Wallet Connect',
                subtitle: 'Connect to external wallets',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletConnectScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlockchainSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Blockchain',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.how_to_vote,
                title: 'DAO Governance',
                subtitle: 'Vote on proposals and participate in governance',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.token,
                title: 'Token Bridge',
                subtitle: 'Transfer tokens across different blockchains',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.verified,
                title: 'Identity Verification',
                subtitle: 'Manage your decentralized identity',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.bar_chart,
                title: 'Network Stats',
                subtitle: 'View blockchain network statistics',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.security,
                title: 'Security Center',
                subtitle: 'Manage your security settings',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.account_balance_wallet,
                title: 'Wallet Backup',
                subtitle: 'Backup your wallet and recovery phrases',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.verified_user,
                title: 'KYC Verification',
                subtitle: 'Complete your identity verification',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeFiSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DeFi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.swap_horiz,
                title: 'Swap',
                subtitle: 'Exchange tokens at the best rates',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SwapScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.water_drop,
                title: 'Liquidity Pools',
                subtitle: 'Provide liquidity and earn fees',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiquidityPoolsScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.trending_up,
                title: 'Yield Farming',
                subtitle: 'Stake LP tokens to earn additional rewards',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YieldFarmingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGovernanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Governance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.how_to_vote,
                title: 'DAO Governance',
                subtitle: 'Vote on proposals and participate in decision-making',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GovernanceScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.account_balance,
                title: 'Treasury',
                subtitle: 'View DAO treasury funds and allocations',
                onTap: () {
                  // Will be implemented in the next part
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.help,
                title: 'Help Center',
                subtitle: 'Get help and support',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.info,
                title: 'About',
                subtitle: 'Learn more about Lifechain',
                onTap: () {},
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                textColor: Colors.red,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
