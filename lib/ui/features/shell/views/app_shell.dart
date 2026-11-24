import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../home/view_models/home_view_model.dart';
import '../../home/views/home_screen.dart';

/// Gyoker scaffold a design negy fules also savjaval. A Sprint 1-ben csak a
/// "Today" ful mukodik, a tobbi helyettesito szoveget mutat.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    (icon: Icons.wb_sunny_outlined, label: 'Today'),
    (icon: Icons.restaurant_menu_outlined, label: 'Meal Plan'),
    (icon: Icons.shopping_basket_outlined, label: 'Grocery List'),
    (icon: Icons.chat_bubble_outline, label: 'Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(viewModel: widget.homeViewModel),
          for (final tab in _tabs.skip(1)) _ComingSoon(title: tab.label),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        elevation: 0,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textPrimary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title is coming in a later sprint.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
