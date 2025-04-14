import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.icon,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final buttonColor = backgroundColor ?? (type == ButtonType.primary
        ? color ?? AppTheme.primaryColor
        : type == ButtonType.secondary
            ? color ?? AppTheme.secondaryColor
            : Colors.white);
    final buttonTextColor = type == ButtonType.outline
        ? textColor ?? AppTheme.primaryColor
        : textColor ?? Colors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: buttonTextColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: type == ButtonType.outline
              ? BorderSide(color: borderColor ?? AppTheme.primaryColor, width: 1.5)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: buttonTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
