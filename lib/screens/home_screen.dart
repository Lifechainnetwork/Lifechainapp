import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/price_chart.dart';
import '../widgets/news_card.dart';
import '../screens/settings_screen.dart';
import '../widgets/lcn_logo_widget.dart';
import '../screens/mining_screen.dart';
import '../screens/yield_farming_screen.dart';
import '../screens/staking_screen.dart';
import '../screens/swap_screen.dart';
import '../screens/liquidity_pools_screen.dart';
import '../screens/governance_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/notifications_screen.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildPromotionCard(),
              const SizedBox(height: 24),
              _buildPriceChart(),
              const SizedBox(height: 24),
              _buildFeatureGrid(),
              const SizedBox(height: 24),
              _buildNewsSection(),
              const SizedBox(height: 24),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(26), // 0.1 opacity is approximately 26 alpha
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: LCNLogoWidget(size: 32),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lifechain LCN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Consumer<NotificationService>(
              builder: (context, notificationService, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    if (notificationService.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${notificationService.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
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
      ],
    );
  }

  Widget _buildPromotionCard() {
    return CustomCard(
      color: const Color(0xFF162232),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Earn Rewards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$100,000 USDT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Explore Now',
                  onPressed: () {},
                  width: 120,
                  height: 40,
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/promo_image.png',
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 100,
                color: AppTheme.primaryColor.withAlpha(77), // 0.3 opacity is approximately 77 alpha
                child: const Icon(
                  Icons.image,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: PriceChart(
        tokenSymbol: 'LCN',
        priceData: PriceChart.getDemoPositiveData(),
        minY: 1.0,
        maxY: 3.0,
        isPositive: true,
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'icon': Icons.memory, 
        'title': 'Mining', 
        'color': Colors.blue,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MiningScreen()),
          );
        },
      },
      {
        'icon': Icons.trending_up, 
        'title': 'Farming', 
        'color': Colors.green,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const YieldFarmingScreen()),
          );
        },
      },
      {
        'icon': Icons.account_balance, 
        'title': 'Staking', 
        'color': Colors.orange,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StakingScreen()),
          );
        },
      },
      {
        'icon': Icons.swap_horiz, 
        'title': 'Swap', 
        'color': Colors.purple,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SwapScreen()),
          );
        },
      },
      {
        'icon': Icons.water_drop, 
        'title': 'Pools', 
        'color': Colors.teal,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LiquidityPoolsScreen()),
          );
        },
      },
      {
        'icon': Icons.how_to_vote, 
        'title': 'Governance', 
        'color': Colors.amber,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GovernanceScreen()),
          );
        },
      },
      {
        'icon': Icons.wallet, 
        'title': 'Wallet', 
        'color': Colors.red,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WalletScreen()),
          );
        },
      },
      {
        'icon': Icons.settings, 
        'title': 'Settings', 
        'color': Colors.indigo,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        final onTap = feature['onTap'] as Function(BuildContext);
        return GestureDetector(
          onTap: () => onTap(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dividerColor, width: 1),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: feature['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feature['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsSection() {
    final newsList = NewsCard.getDemoNews();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest News',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsList.length > 3 ? 3 : newsList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return NewsCard(newsItem: newsList[index], onTap: () {});
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            onTap: () {},
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, color: AppTheme.primaryColor, size: 24),
                SizedBox(height: 8),
                Text(
                  'Community',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomCard(
            onTap: () {},
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_esports,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  'Gaming Zone',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
