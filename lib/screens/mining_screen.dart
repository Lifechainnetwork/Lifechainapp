import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class MiningScreen extends StatefulWidget {
  const MiningScreen({super.key});

  @override
  State<MiningScreen> createState() => _MiningScreenState();
}

class _MiningScreenState extends State<MiningScreen> with SingleTickerProviderStateMixin {
  bool _isMining = false;
  int _miningSeconds = 0;
  late Timer _timer;
  double _hashRate = 0.0;
  int _totalMined = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    if (_isMining) {
      _timer.cancel();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _startMining() {
    setState(() {
      _isMining = true;
      _miningSeconds = 0;
      _hashRate = 0.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _miningSeconds++;
        // Simulate increasing hash rate over time
        _hashRate = (_miningSeconds * 0.5).clamp(0.0, 50.0);
        
        // Simulate mining rewards (every 10 seconds)
        if (_miningSeconds % 10 == 0 && _miningSeconds > 0) {
          _totalMined += (_hashRate * 0.01).round();
        }
      });
    });
  }

  void _stopMining() {
    if (_isMining) {
      _timer.cancel();
      setState(() {
        _isMining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mining'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMiningStatus(),
            const SizedBox(height: 24),
            _buildHashrateCard(),
            const SizedBox(height: 24),
            _buildMiningStats(),
            const SizedBox(height: 24),
            _buildMiningButton(),
            const SizedBox(height: 24),
            _buildMiningHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildMiningStatus() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mining Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _isMining ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isMining ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isMining ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: _isMining ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isMining)
            Column(
              children: [
                const Text(
                  'Mining in progress...',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time elapsed: ${_formatDuration(_miningSeconds)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          else
            const Text(
              'Start mining to earn LCN tokens',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHashrateCard() {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Hashrate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _isMining ? _animation.value * 2 * 3.14159 : 0,
                    child: Icon(
                      Icons.settings,
                      color: _isMining ? AppTheme.primaryColor : Colors.grey,
                      size: 36,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_hashRate.toStringAsFixed(2)} H/s',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isMining ? 'Mining at optimal performance' : 'Mining is inactive',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _hashRate / 50.0,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              _isMining ? AppTheme.primaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiningStats() {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Mined',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$_totalMined LCN',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mining Efficiency',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${(_hashRate > 0 ? (_hashRate * 0.01).toStringAsFixed(2) : '0.00')} LCN/min',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiningButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_isMining) {
            _stopMining();
          } else {
            _startMining();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isMining ? Colors.red : AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isMining ? Icons.stop : Icons.play_arrow,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _isMining ? 'Stop Mining' : 'Start Mining',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiningHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mining History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _buildMiningHistoryItem(
                date: DateTime.now().subtract(const Duration(days: 1)),
                duration: 3600,
                amount: 45,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMiningHistoryItem(
                date: DateTime.now().subtract(const Duration(days: 2)),
                duration: 7200,
                amount: 92,
              ),
              const Divider(height: 1, color: AppTheme.dividerColor),
              _buildMiningHistoryItem(
                date: DateTime.now().subtract(const Duration(days: 3)),
                duration: 5400,
                amount: 67,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiningHistoryItem({
    required DateTime date,
    required int duration,
    required int amount,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.memory,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${_formatDuration(duration)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+$amount LCN',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    String hoursStr = hours > 0 ? '${hours}h ' : '';
    String minutesStr = minutes > 0 ? '${minutes}m ' : '';
    String secondsStr = '${remainingSeconds}s';
    
    return '$hoursStr$minutesStr$secondsStr';
  }
}
