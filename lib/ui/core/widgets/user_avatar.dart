import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Kerek profilkep, kep helyett a nev kezdobetujevel.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 36, this.initial = 'R'});

  final double size;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.surfaceMuted,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
