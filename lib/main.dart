import 'package:flutter/material.dart';
import 'package:finzy/routes/app_routes.dart';
import 'package:finzy/theme/app_theme.dart';

void main() {
  runApp(const FinzyApp());
}

class FinzyApp extends StatelessWidget {
  const FinzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finzy',
      debugShowCheckedModeBanner: false,
      theme: FinzyTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
