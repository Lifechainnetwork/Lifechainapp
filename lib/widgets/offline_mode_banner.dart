import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../providers/connectivity_provider.dart';
import '../services/sync_manager.dart';
import '../theme/app_theme.dart';

class OfflineModeBanner extends StatefulWidget {
  final VoidCallback? onRefresh;

  const OfflineModeBanner({super.key, this.onRefresh});

  @override
  State<OfflineModeBanner> createState() => _OfflineModeBannerState();
}

class _OfflineModeBannerState extends State<OfflineModeBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        final isOffline =
            connectivityProvider.connectivityResult == ConnectivityResult.none;

        // Control animation based on connectivity status
        if (isOffline && !_wasOffline) {
          _animationController.forward();
        } else if (!isOffline && _wasOffline) {
          _animationController.reverse();
        }

        _wasOffline = isOffline;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            if (_animationController.isDismissed) {
              return const SizedBox.shrink();
            }

            return Opacity(
              opacity: _heightAnimation.value,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 60 * _heightAnimation.value,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9 * 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2 * 255),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.signal_wifi_off, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'You are offline',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Only cached data is available',
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: 0.8 * 255,
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<SyncManager>(
                          builder: (context, syncManager, _) {
                            return _buildRefreshButton(
                              context,
                              syncManager.isSyncing,
                              () {
                                if (widget.onRefresh != null) {
                                  widget.onRefresh!();
                                } else {
                                  _tryManualSync(context);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRefreshButton(
    BuildContext context,
    bool isSyncing,
    VoidCallback onPressed,
  ) {
    if (isSyncing) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(80, 30),
      ),
      child: const Text('Retry', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _tryManualSync(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    );
    final syncManager = Provider.of<SyncManager>(context, listen: false);

    // Check if we have connectivity
    if (connectivityProvider.connectivityResult != ConnectivityResult.none) {
      // We're online, start sync
      syncManager.syncDataWithServer();

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syncing data...'),
          backgroundColor: AppTheme.primaryColor,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Still offline, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Still offline. Please check your connection.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
