import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipie_app/Provider/favourite_provider.dart';
import 'package:recipie_app/Provider/quantity.dart';
import 'package:provider/provider.dart';
import 'screens/app_main_screen.dart';
import 'package:recipie_app/Provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    // Here we don't need to access ThemeProvider directly in MyApp
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()), // Favorite provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()), // Quantity provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: AppMainScreen(),
          );
        },
      ),
    );
  }
}
