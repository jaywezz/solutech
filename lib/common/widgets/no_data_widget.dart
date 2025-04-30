import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const NoDataWidget({
    super.key,
    this.message = "No data available",
    this.icon = Icons.info_outline,
    this.iconSize = 48,
    this.iconColor,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message!,
              style: textStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 