import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymtrack/config/router/app_router.dart';
import 'package:gymtrack/config/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
     debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
     theme: AppTheme().themeData,
    );
  }
}