import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'services/localization_service.dart';
import 'screens/home_screen.dart';
import 'screens/admin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.initialize();
  
  // Initialize localization
  final localizationService = LocalizationService();
  await localizationService.loadLanguage();
  
  runApp(
    ChangeNotifierProvider.value(
      value: localizationService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationService>();
    
    return MaterialApp(
      title: localization.translate('app_title'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(8),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/admin': (context) => const AdminLoginScreen(),
      },
    );
  }
}
