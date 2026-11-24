import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/shell/views/app_shell.dart';

void main() {
  runApp(
    MultiProvider(
      providers: appProviders(),
      child: const MealPlannerApp(),
    ),
  );
}

class MealPlannerApp extends StatelessWidget {
  const MealPlannerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Builder(
        builder: (context) => AppShell(
          homeViewModel: context.read<HomeViewModel>(),
        ),
      ),
    );
  }
}
