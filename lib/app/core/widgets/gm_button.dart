import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Custom Button Widget (Themed & Responsive)
// ════════════════════════════════════════════════════════════════════════════

enum GMButtonType { primary, secondary, outlined, text }

class GMButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final GMButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const GMButton({
    required this.text,
    this.onPressed,
    this.type = GMButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 50.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == GMButtonType.outlined || type == GMButtonType.text
                    ? theme.primaryColor
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButtonWidget(context, theme, child),
    );
  }

  Widget _buildButtonWidget(BuildContext context, ThemeData theme, Widget child) {
    switch (type) {
      case GMButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: child,
        );
      case GMButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: child,
        );
      case GMButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: child,
        );
      case GMButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: child,
        );
    }
  }
}
