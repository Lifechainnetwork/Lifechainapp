import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../models/token.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  
  // Demo tokens for testing
  final List<Token> demoTokens = [
    Token(
      id: '1',
      name: 'Lifechain Token',
      symbol: 'LCT',
      decimals: 18,
      totalSupply: '1000000000',
      owner: '0x123456789',
      balance: 1250.75,
      price: 2.34,
    ),
    Token(
      id: '2',
      name: 'Ethereum',
      symbol: 'ETH',
      decimals: 18,
      totalSupply: '115000000',
      owner: '0x987654321',
      balance: 3.45,
      price: 3200.50,
    ),
    Token(
      id: '3',
      name: 'Binance Coin',
      symbol: 'BNB',
      decimals: 18,
      totalSupply: '200000000',
      owner: '0xabcdef123',
      balance: 12.5,
      price: 420.75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WALLET'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletActions(),
            const SizedBox(height: 24),
            const Text(
              'BALANCE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            _buildTokenList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.send, 'Send'),
        _buildActionButton(Icons.download, 'Receive'),
        _buildActionButton(Icons.history, 'History'),
        _buildActionButton(Icons.download_outlined, 'Withdraw'),
        _buildActionButton(Icons.trending_up, 'Stake'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTokenList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demoTokens.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final token = demoTokens[index];
        return CustomCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(51), // 0.2 opacity is approximately 51 alpha
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    token.symbol.substring(0, 1),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.symbol,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      token.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${token.balance}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${(token.balance * token.price).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }
}
