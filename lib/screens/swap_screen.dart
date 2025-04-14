import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/token_pair.dart';
import '../widgets/custom_card.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();

  String _fromToken = 'LCN';
  String _toToken = 'ETH';
  bool _isLoading = false;
  bool _isReversed = false;
  double _slippageTolerance = 0.5; // 0.5%

  List<TokenPair> _tokenPairs = [];
  TokenPair? _selectedPair;

  @override
  void initState() {
    super.initState();
    _loadTokenPairs();
    _fromAmountController.text = '1';
  }

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadTokenPairs() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _tokenPairs = TokenPair.getDemoData();
      _updateSelectedPair();
      _calculateToAmount();
      _isLoading = false;
    });
  }

  void _updateSelectedPair() {
    // Find the pair that matches the selected tokens
    final pairId1 = '$_fromToken-$_toToken'.toLowerCase();
    final pairId2 = '$_toToken-$_fromToken'.toLowerCase();

    _selectedPair = _tokenPairs.firstWhere(
      (pair) =>
          pair.id.toLowerCase() == pairId1 || pair.id.toLowerCase() == pairId2,
      orElse: () => _tokenPairs.first,
    );

    // Determine if the pair is reversed relative to our token order
    _isReversed = _selectedPair?.baseToken != _fromToken;
  }

  void _swapTokens() {
    final temp = _fromToken;
    _fromToken = _toToken;
    _toToken = temp;

    final tempAmount = _fromAmountController.text;
    _fromAmountController.text = _toAmountController.text;
    _toAmountController.text = tempAmount;

    setState(() {
      _updateSelectedPair();
    });
  }

  void _calculateToAmount() {
    if (_selectedPair == null || _fromAmountController.text.isEmpty) {
      _toAmountController.text = '';
      return;
    }

    try {
      final fromAmount = double.parse(_fromAmountController.text);
      double toAmount;

      if (_isReversed) {
        // If the pair is reversed, use the inverse price
        toAmount = fromAmount * (1 / _selectedPair!.price);
      } else {
        toAmount = fromAmount * _selectedPair!.price;
      }

      _toAmountController.text = toAmount.toStringAsFixed(6);
    } catch (e) {
      _toAmountController.text = '';
    }
  }

  void _calculateFromAmount() {
    if (_selectedPair == null || _toAmountController.text.isEmpty) {
      _fromAmountController.text = '';
      return;
    }

    try {
      final toAmount = double.parse(_toAmountController.text);
      double fromAmount;

      if (_isReversed) {
        // If the pair is reversed, use the inverse price
        fromAmount = toAmount / (1 / _selectedPair!.price);
      } else {
        fromAmount = toAmount / _selectedPair!.price;
      }

      _fromAmountController.text = fromAmount.toStringAsFixed(6);
    } catch (e) {
      _fromAmountController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Swap'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSwapCard(),
                    const SizedBox(height: 24),
                    if (_selectedPair != null) _buildPriceInfo(),
                    const SizedBox(height: 24),
                    _buildSwapSettings(),
                  ],
                ),
              ),
    );
  }

  Widget _buildSwapCard() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFromTokenInput(),
          const SizedBox(height: 8),
          _buildSwapButton(),
          const SizedBox(height: 8),
          _buildToTokenInput(),
          const SizedBox(height: 24),
          _buildSwapButton(),
        ],
      ),
    );
  }

  Widget _buildFromTokenInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withValues(alpha: 0.5 * 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('From', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fromAmountController,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    _calculateToAmount();
                  },
                ),
              ),
              const SizedBox(width: 16),
              _buildTokenSelector(_fromToken, (newToken) {
                if (newToken != _toToken) {
                  setState(() {
                    _fromToken = newToken;
                    _updateSelectedPair();
                    _calculateToAmount();
                  });
                }
              }),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Balance: 1,000 $_fromToken',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildToTokenInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withValues(alpha: 0.5 * 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('To', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _toAmountController,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    hintText: '0.0',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    _calculateFromAmount();
                  },
                ),
              ),
              const SizedBox(width: 16),
              _buildTokenSelector(_toToken, (newToken) {
                if (newToken != _fromToken) {
                  setState(() {
                    _toToken = newToken;
                    _updateSelectedPair();
                    _calculateToAmount();
                  });
                }
              }),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Balance: 0.5 $_toToken',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSelector(String currentToken, Function(String) onSelect) {
    return InkWell(
      onTap: () {
        _showTokenSelectDialog(context, currentToken, onSelect);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildTokenIcon(currentToken),
            const SizedBox(width: 8),
            Text(
              currentToken,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
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
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.2 * 255),
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 1),
      ),
      child: Center(
        child: Text(
          symbol.substring(0, 1),
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildSwapButton() {
    return Center(
      child: InkWell(
        onTap: _swapTokens,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.dividerColor, width: 1),
          ),
          child: const Icon(Icons.swap_vert, color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    final priceDisplay =
        _isReversed
            ? '1 $_fromToken = ${(1 / _selectedPair!.price).toStringAsFixed(6)} $_toToken'
            : '1 $_fromToken = ${_selectedPair!.price.toStringAsFixed(6)} $_toToken';

    final priceImpact =
        0.12; // This would be calculated based on order size in a real app

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Row(
                children: [
                  Text(
                    priceDisplay,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _selectedPair!.priceChange24h >= 0
                              ? Colors.green.withValues(alpha: 0.2 * 255)
                              : Colors.red.withValues(alpha: 0.2 * 255),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${_selectedPair!.priceChange24h >= 0 ? '+' : ''}${_selectedPair!.priceChange24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color:
                            _selectedPair!.priceChange24h >= 0
                                ? Colors.green
                                : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Impact',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Text(
                '${priceImpact.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: priceImpact < 1 ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Liquidity Provider Fee',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Text(
                '0.3%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Route',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Text(
                '$_fromToken > $_toToken',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Minimum Received',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              Text(
                _calculateMinimumReceived(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwapSettings() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Slippage Tolerance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSlippageOption(0.1),
              const SizedBox(width: 8),
              _buildSlippageOption(0.5),
              const SizedBox(width: 8),
              _buildSlippageOption(1.0),
              const SizedBox(width: 8),
              _buildCustomSlippageOption(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _fromAmountController.text.isNotEmpty &&
                          _toAmountController.text.isNotEmpty
                      ? _executeSwap
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.5),
              ),
              child: const Text(
                'Swap',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlippageOption(double value) {
    final isSelected = _slippageTolerance == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _slippageTolerance = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.2 * 255)
                    : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSlippageOption() {
    final isCustom = ![0.1, 0.5, 1.0].contains(_slippageTolerance);

    return Expanded(
      child: InkWell(
        onTap: () {
          _showCustomSlippageDialog(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isCustom
                    ? AppTheme.primaryColor.withValues(alpha: 0.2 * 255)
                    : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCustom ? AppTheme.primaryColor : AppTheme.dividerColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              isCustom ? '${_slippageTolerance.toStringAsFixed(1)}%' : 'Custom',
              style: TextStyle(
                color: isCustom ? AppTheme.primaryColor : Colors.white,
                fontWeight: isCustom ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _calculateMinimumReceived() {
    if (_toAmountController.text.isEmpty) return '0 $_toToken';

    try {
      final toAmount = double.parse(_toAmountController.text);
      final minAmount = toAmount * (1 - _slippageTolerance / 100);
      return '${minAmount.toStringAsFixed(6)} $_toToken';
    } catch (e) {
      return '0 $_toToken';
    }
  }

  void _executeSwap() {
    // In a real app, this would call the blockchain to execute the swap
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Swap Confirmation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Swap ${_fromAmountController.text} $_fromToken for ${_toAmountController.text} $_toToken?',
                ),
                const SizedBox(height: 16),
                Text('Minimum received: ${_calculateMinimumReceived()}'),
                const SizedBox(height: 8),
                Text(
                  'Slippage tolerance: ${_slippageTolerance.toStringAsFixed(1)}%',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSwapSuccessDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Swap'),
              ),
            ],
          ),
    );
  }

  void _showTokenSelectDialog(
    BuildContext context,
    String currentToken,
    Function(String) onSelect,
  ) {
    final availableTokens = ['LCN', 'ETH', 'USDT', 'BNB'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Select Token'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableTokens.length,
                itemBuilder: (context, index) {
                  final token = availableTokens[index];
                  final isSelected = token == currentToken;

                  return ListTile(
                    leading: _buildTokenIcon(token),
                    title: Text(token),
                    trailing:
                        isSelected
                            ? const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryColor,
                            )
                            : null,
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(token);
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  void _showCustomSlippageDialog(BuildContext context) {
    final controller = TextEditingController(
      text: _slippageTolerance.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Custom Slippage'),
            content: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                suffixText: '%',
                hintText: 'Enter slippage percentage',
              ),
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
              ElevatedButton(
                onPressed: () {
                  try {
                    final value = double.parse(controller.text);
                    if (value > 0 && value <= 20) {
                      setState(() {
                        _slippageTolerance = value;
                      });
                      Navigator.pop(context);
                    } else {
                      // Show error for invalid range
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Slippage must be between 0.1% and 20%',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Show error for invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid slippage value'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _showSwapSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            title: const Text('Swap Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Successfully swapped ${_fromAmountController.text} $_fromToken for ${_toAmountController.text} $_toToken',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Transaction Hash:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '0x${_generateFakeTransactionHash()}',
                  style: const TextStyle(fontSize: 12),
                ),
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

  String _generateFakeTransactionHash() {
    const chars = 'abcdef0123456789';
    String result = '';
    for (int i = 0; i < 64; i++) {
      result += chars[DateTime.now().millisecondsSinceEpoch % chars.length];
    }
    return result;
  }
}
