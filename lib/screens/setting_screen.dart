import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipie_app/screens/auth_screen.dart';
import 'package:recipie_app/screens/miscellenous_screen.dart';
import 'package:recipie_app/Utils/notification_helper.dart';
import 'package:recipie_app/Provider/notification_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late NotificationHelper notificationHelper;
  bool areNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationHelper();
  }


  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About Us"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text("Theme Change"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeChangeScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Notifications"),
            trailing: Switch(
              value: notificationProvider.areNotificationsEnabled,
              onChanged: (value) => notificationProvider.toggleNotifications(value),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.contact_page_outlined),
            title: const Text("Contact us"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactUsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () async {
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Log Out"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              ) ?? false;

              if (confirmLogout) {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
