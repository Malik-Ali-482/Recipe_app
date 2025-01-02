import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipie_app/Provider/favourite_provider.dart';
import 'package:recipie_app/Provider/quantity.dart';
import 'package:provider/provider.dart';
import 'screens/auth_gate.dart';
import 'package:recipie_app/Provider/theme_provider.dart';
import 'package:recipie_app/Provider/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()), // Favorite provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()), // Quantity provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: AuthGate(),
          );
        },
      ),
    );
  }
}
