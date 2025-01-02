import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipie_app/screens/app_main_screen.dart';
import 'package:recipie_app/screens/auth_screen.dart';
import 'package:recipie_app/Provider/favourite_provider.dart'; // Adjust the path as needed

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return ChangeNotifierProvider(
              create: (_) {
                final favoriteProvider = FavoriteProvider();
                if (user != null) {
                  favoriteProvider.setUserId(user.uid);
                }
                return favoriteProvider;
              },
              child: const AppMainScreen(),
            );
          } else {
            // User is not logged in
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
