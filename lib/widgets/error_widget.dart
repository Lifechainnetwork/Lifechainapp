import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final bool showRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 12),
              Text(
                details!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (showRetry && onRetry != null) ...[
              const SizedBox(height: 24),
              AnimatedButton(
                text: 'Try Again',
                icon: Icons.refresh,
                onPressed: onRetry!,
                width: 150,
                color: AppTheme.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
