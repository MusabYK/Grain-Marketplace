import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/auth/pages/auth_screen.dart';
import 'presentation/auth/providers/auth_provider.dart';
import 'presentation/farmer/providers/farmer_dashboard_provider.dart';
import 'presentation/buyer/providers/buyer_dashboard_provider.dart';
// If you add order-specific providers, include them here.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FarmerDashboardProvider()),
        ChangeNotifierProvider(create: (_) => BuyerDashboardProvider()),
        // Add more providers as your app grows, e.g., OrderProvider()
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrainMarketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: const AuthScreen(),
    );
  }
}
