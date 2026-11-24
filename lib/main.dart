import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/dependencies.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/shell/views/app_shell.dart';

Future<void> main() async {
  // A SharedPreferences-t az app indulasa elott toltjuk be, igy a mentett
  // kedvencek mar az elso kepkockan latszanak.
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: appProviders(prefs: prefs),
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
