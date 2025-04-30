import 'package:flutter/material.dart';
import 'package:solutench/services/go_router_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solutench/theme.dart';

void main() {
  runApp(const ProviderScope(
        child: MainApp()
      ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          title: 'Solutech',
          routerConfig: goRouter,
        );
  }
}
