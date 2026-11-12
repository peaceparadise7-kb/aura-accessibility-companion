import 'package:flutter/material.dart';
import 'package:aura_mobile/core/constants/app_constants.dart';

/// Accessibility-compliant button enforcing minimum 48x48dp touch targets,
/// high contrast colors, and explicit screen-reader semantics.
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? semanticHint;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final double minHeight;

  const AccessibleButton({
    super.key,
    required this.label,
    this.semanticHint,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.minHeight = AppConstants.largeTouchTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonWidget = isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, minHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.standardPadding,
                vertical: 14.0,
              ),
            ),
            child: _buildContent(theme),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, minHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.standardPadding,
                vertical: 14.0,
              ),
            ),
            child: _buildContent(theme),
          );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      hint: semanticHint,
      child: buttonWidget,
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (icon == null) {
      return Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24.0),
        const SizedBox(width: 12.0),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
