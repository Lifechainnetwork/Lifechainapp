import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_connect_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class WalletConnectScreen extends StatefulWidget {
  const WalletConnectScreen({super.key});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeWalletService();
  }

  Future<void> _initializeWalletService() async {
    final walletService = Provider.of<WalletConnectService>(
      context,
      listen: false,
    );

    if (!walletService.isInitialized) {
      setState(() {
        _isLoading = true;
      });

      await walletService.initialize();

      setState(() {
        _isLoading = false;
        _error = walletService.lastError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Connect Wallet'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : Consumer<WalletConnectService>(
                builder: (context, walletService, child) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildConnectHeader(),
                        const SizedBox(height: 24),
                        if (walletService.isConnected)
                          _buildConnectedWalletInfo(walletService)
                        else
                          _buildWalletOptions(walletService),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          _buildErrorMessage(),
                        ],
                        const SizedBox(height: 24),
                        if (walletService.recentWallets.isNotEmpty &&
                            !walletService.isConnected) ...[
                          _buildRecentWallets(walletService),
                        ],
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildConnectHeader() {
    return const CustomCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect Your Wallet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Connect your wallet to access all features of the Lifechain ecosystem including staking, governance, and more.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedWalletInfo(WalletConnectService walletService) {
    final wallet = walletService.connectedWallet!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildWalletIcon(wallet.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getWalletName(wallet.type),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatAddress(wallet.address),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.content_copy,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    onPressed: () {
                      _copyToClipboard(wallet.address);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppTheme.dividerColor),
              const SizedBox(height: 16),
              FutureBuilder<String>(
                future: walletService.getBalance(),
                builder: (context, snapshot) {
                  final balance = snapshot.data ?? '0';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      Text(
                        '$balance ETH',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Network',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  Text(
                    _getNetworkName(wallet.chainId),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Switch Network',
                      onPressed: () {
                        _showNetworkSwitchDialog(context, walletService);
                      },
                      color: Colors.transparent,
                      textColor: AppTheme.primaryColor,
                      borderColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Disconnect',
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await walletService.disconnectWallet();

                        setState(() {
                          _isLoading = false;
                          _error = walletService.lastError;
                        });
                      },
                      color: Colors.red.withValues(alpha: 0.1 * 255),
                      textColor: Colors.red,
                      borderColor: Colors.red.withValues(alpha: 0.3 * 255),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Sign Test Message',
                onPressed: () {
                  _signTestMessage(walletService);
                },
                color: AppTheme.primaryColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletOptions(WalletConnectService walletService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Wallet',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildWalletOption(
                walletType: WalletType.metamask,
                name: 'MetaMask',
                description: 'Connect to your MetaMask wallet',
                walletService: walletService,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildWalletOption(
                walletType: WalletType.trustWallet,
                name: 'Trust Wallet',
                description: 'Connect to your Trust Wallet',
                walletService: walletService,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildWalletOption(
                walletType: WalletType.coinbaseWallet,
                name: 'Coinbase Wallet',
                description: 'Connect to your Coinbase Wallet',
                walletService: walletService,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildWalletOption(
                walletType: WalletType.ledger,
                name: 'Ledger',
                description: 'Connect to your Ledger hardware wallet',
                walletService: walletService,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildWalletOption(
                walletType: WalletType.walletConnect,
                name: 'WalletConnect',
                description: 'Connect with WalletConnect protocol',
                walletService: walletService,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletOption({
    required WalletType walletType,
    required String name,
    required String description,
    required WalletConnectService walletService,
  }) {
    return InkWell(
      onTap: () async {
        setState(() {
          _isLoading = true;
          _error = null;
        });

        final success = await walletService.connectWallet(walletType);

        setState(() {
          _isLoading = false;
          if (!success) {
            _error = walletService.lastError;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildWalletIcon(walletType),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWallets(WalletConnectService walletService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Wallets',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children:
                walletService.recentWallets.map((wallet) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });

                          final success = await walletService.connectWallet(
                            wallet.type,
                            chainId: wallet.chainId,
                          );

                          setState(() {
                            _isLoading = false;
                            if (!success) {
                              _error = walletService.lastError;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              _buildWalletIcon(wallet.type),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getWalletName(wallet.type),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatAddress(wallet.address),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (wallet != walletService.recentWallets.last)
                        const Divider(height: 1, color: AppTheme.dividerColor),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1 * 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3 * 255),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error ?? 'An error occurred',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletIcon(WalletType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case WalletType.metamask:
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.orange;
        break;
      case WalletType.trustWallet:
        iconData = Icons.shield;
        iconColor = Colors.blue;
        break;
      case WalletType.coinbaseWallet:
        iconData = Icons.monetization_on;
        iconColor = Colors.blue;
        break;
      case WalletType.ledger:
        iconData = Icons.security;
        iconColor = Colors.green;
        break;
      case WalletType.trezor:
        iconData = Icons.lock;
        iconColor = Colors.black;
        break;
      case WalletType.phantom:
        iconData = Icons.auto_awesome;
        iconColor = Colors.purple;
        break;
      case WalletType.walletConnect:
        iconData = Icons.link;
        iconColor = Colors.blue;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1 * 255),
        shape: BoxShape.circle,
      ),
      child: Center(child: Icon(iconData, color: iconColor, size: 20)),
    );
  }

  String _getWalletName(WalletType type) {
    switch (type) {
      case WalletType.metamask:
        return 'MetaMask';
      case WalletType.trustWallet:
        return 'Trust Wallet';
      case WalletType.coinbaseWallet:
        return 'Coinbase Wallet';
      case WalletType.ledger:
        return 'Ledger';
      case WalletType.trezor:
        return 'Trezor';
      case WalletType.phantom:
        return 'Phantom';
      case WalletType.walletConnect:
        return 'WalletConnect';
    }
  }

  String _formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String _getNetworkName(String chainId) {
    switch (chainId) {
      case '0x1':
        return 'Ethereum Mainnet';
      case '0x5':
        return 'Goerli Testnet';
      case '0x89':
        return 'Polygon Mainnet';
      case '0x13881':
        return 'Mumbai Testnet';
      case '0x38':
        return 'BNB Smart Chain';
      case '0xa86a':
        return 'Avalanche C-Chain';
      default:
        return 'Unknown Network';
    }
  }

  void _copyToClipboard(String text) {
    // In a real app, you would use clipboard functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _signTestMessage(WalletConnectService walletService) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final message = 'Hello from Lifechain App! ${DateTime.now()}';
    final signature = await walletService.signMessage(message);

    setState(() {
      _isLoading = false;
    });

    if (signature != null) {
      _showSignatureDialog(context, message, signature);
    } else {
      setState(() {
        _error = walletService.lastError ?? 'Failed to sign message';
      });
    }
  }

  void _showSignatureDialog(
    BuildContext context,
    String message,
    String signature,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Message Signed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(message),
                const SizedBox(height: 16),
                const Text(
                  'Signature:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(signature, style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
    );
  }

  void _showNetworkSwitchDialog(
    BuildContext context,
    WalletConnectService walletService,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Switch Network'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNetworkOption(
                  context,
                  'Ethereum Mainnet',
                  '0x1',
                  walletService,
                ),
                _buildNetworkOption(
                  context,
                  'Goerli Testnet',
                  '0x5',
                  walletService,
                ),
                _buildNetworkOption(
                  context,
                  'Polygon Mainnet',
                  '0x89',
                  walletService,
                ),
                _buildNetworkOption(
                  context,
                  'Mumbai Testnet',
                  '0x13881',
                  walletService,
                ),
                _buildNetworkOption(
                  context,
                  'BNB Smart Chain',
                  '0x38',
                  walletService,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildNetworkOption(
    BuildContext context,
    String name,
    String chainId,
    WalletConnectService walletService,
  ) {
    final isCurrentNetwork = walletService.connectedWallet?.chainId == chainId;

    return InkWell(
      onTap:
          isCurrentNetwork
              ? null
              : () async {
                Navigator.pop(context);

                setState(() {
                  _isLoading = true;
                  _error = null;
                });

                final success = await walletService.switchChain(chainId);

                setState(() {
                  _isLoading = false;
                  if (!success) {
                    _error = walletService.lastError;
                  }
                });
              },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: isCurrentNetwork ? AppTheme.primaryColor : Colors.white,
                fontWeight:
                    isCurrentNetwork ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isCurrentNetwork)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
