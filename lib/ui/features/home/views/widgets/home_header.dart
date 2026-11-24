import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/user_avatar.dart';

/// A Home kepernyo felso sava: balra profilkep, jobbra menu.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const UserAvatar(),
        IconButton(
          tooltip: 'Menu',
          onPressed: onMenuPressed,
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
