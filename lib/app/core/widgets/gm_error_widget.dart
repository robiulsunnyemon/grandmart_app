import 'package:flutter/material.dart';
import 'gm_button.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Error & Retry State Widget
// ════════════════════════════════════════════════════════════════════════════

class GMErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const GMErrorWidget({
    this.message = 'Something went wrong. Please try again.',
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              GMButton(
                text: 'Retry',
                icon: Icons.refresh_rounded,
                width: 140,
                height: 44,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
