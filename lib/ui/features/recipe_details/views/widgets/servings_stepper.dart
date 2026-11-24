import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Keretes minusz / plusz vezerlo. Null callback eseten az az oldal tiltott.
class ServingsStepper extends StatelessWidget {
  const ServingsStepper({
    super.key,
    required this.onDecrement,
    required this.onIncrement,
  });

  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textPrimary),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            tooltip: 'Fewer servings',
            onPressed: onDecrement,
          ),
          Container(width: 1, height: 20, color: AppColors.textPrimary),
          _StepButton(
            icon: Icons.add,
            tooltip: 'More servings',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 32,
          height: 24,
          child: Icon(
            icon,
            size: 16,
            color: onPressed == null
                ? AppColors.textDisabled
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
