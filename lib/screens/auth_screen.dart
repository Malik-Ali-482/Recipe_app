import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_main_screen.dart';
import 'package:recipie_app/Provider/favourite_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  String passwordError = '';

  List<String> validatePassword(String password) {
    List<String> errors = [];
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      errors.add('Password must contain at least one uppercase letter.\n');
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      errors.add('Password must contain at least one lowercase letter.\n');
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      errors.add('Password must contain at least one digit.\n');
    }
    if (!RegExp(r'(?=.*[!@#$%^&*])').hasMatch(password)) {
      errors.add('Password must contain at least one special character.\n');
    }
    if (password.length < 8) {
      errors.add('Password must be at least 8 characters long.\n');
    }
    return errors;
  }

  Future<void> authenticate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    List<String> passwordErrors = validatePassword(password);
    if (passwordErrors.isNotEmpty) {
      setState(() {
        passwordError = passwordErrors.join('\n');
      });
      return;
    } else {
      setState(() {
        passwordError = '';
      });
    }

    if (email.isEmpty || password.isEmpty || (!isLogin && username.isEmpty)) {
      setState(() {
        passwordError = 'Please fill all fields.';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;
        if (user != null) {
          final favoriteProvider =
          Provider.of<FavoriteProvider>(context, listen: false);
          favoriteProvider.setUserId(user.uid); // Set user ID dynamically

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AppMainScreen(),
            ),
          );
        }
      } else {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user?.updateDisplayName(username);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': email,
          'username': username,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully! Please log in.")),
        );

        setState(() {
          isLogin = true;
        });
      }
    } catch (e) {
      final errorMessage = e is FirebaseAuthException
          ? e.message ?? "An error occurred"
          : "An unexpected error occurred";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? "Login" : "Sign Up",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      if (!isLogin)
                        Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          errorText: passwordError.isNotEmpty ? passwordError : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: authenticate,
                        child: Text(isLogin ? "Login" : "Sign Up"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
