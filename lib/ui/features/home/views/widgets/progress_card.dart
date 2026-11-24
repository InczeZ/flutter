import 'package:flutter/material.dart';

import '../../../../../domain/models/daily_progress.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/user_avatar.dart';
import 'macro_ring.dart';

/// "Today's Progress" kartya: kaloria, harom makro gyuru es egy uzenet.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.progress,
    required this.onViewMore,
  });

  final DailyProgress progress;
  final VoidCallback onViewMore;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Today\'s Progress', style: textTheme.titleMedium),
              ),
              TextButton(
                onPressed: onViewMore,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.link,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                ),
                child: const Text('View more'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calories', style: textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            _formatThousands(progress.calories),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MacroRing(
                value: progress.fatPercent,
                label: 'Fat',
                color: AppColors.macroFat,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroRing(
                value: progress.proteinPercent,
                label: 'Pro',
                color: AppColors.macroProtein,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroRing(
                value: progress.carbsPercent,
                label: 'Carb',
                color: AppColors.macroCarbs,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const UserAvatar(size: 28),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '🎉 ${progress.message}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
