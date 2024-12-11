import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/Provider/theme_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late NotificationHelper notificationHelper;
  bool areNotificationsEnabled = true;
  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationHelper();
    _loadNotificationPreference();
  }
  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      areNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
    if (areNotificationsEnabled) {
      notificationHelper.scheduleMealNotifications();
    }
  }

  void _toggleNotifications(bool value) async {
    setState(() {
      areNotificationsEnabled = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);

    if (value) {
      notificationHelper.scheduleMealNotifications();
    } else {
      notificationHelper.cancelAllNotifications();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          // Terms and Conditions Option
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
          // About Us Option
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
          // Theme Change Option
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text("Theme Change") ,
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
          // Notifications Option
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Notifications"),
            trailing: Switch(
              value: areNotificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),
          const Divider(),
          // Privacy Policy Option
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
          //Contact us
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
          // Log Out Option
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Add your log-out logic here
            },
          ),
        ],
      ),
    );
  }
}
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '''
Please read these terms and conditions carefully before using our app.

1. Acceptance of Terms:
   - By using this app, you agree to comply with these terms and conditions.
   - If you do not agree, please do not use the app.

2. Changes to Terms:
   - We reserve the right to modify or update these terms at any time.
   - Any changes will be communicated via the app, and it is your responsibility to stay updated.

3. User Responsibilities:
   - You are responsible for maintaining the confidentiality of your account and password.
   - You agree to use the app for lawful purposes only and in accordance with applicable laws.

4. Prohibited Activities:
   - You may not use the app for any illegal, harmful, or fraudulent activities.
   - You may not attempt to hack, exploit, or gain unauthorized access to the app’s systems.

5. Privacy:
   - Your use of the app is governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.

6. Disclaimers and Limitations of Liability:
   - We do not guarantee that the app will be free of errors or interruptions.
   - We are not liable for any damages arising from your use or inability to use the app.

7. Governing Law:
   - These terms are governed by the laws of the country where the app is primarily operated.
   - Any disputes arising from these terms will be resolved in the appropriate courts.

If you have any questions or concerns, please contact us at support@example.com.

By using this app, you agree to these Terms and Conditions.
              ''',
              style: TextStyle(
                fontSize: 16.0,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '''
Welcome to our app, designed to help you explore, create, and discover new recipes! We aim to provide users with an easy-to-use platform that enhances their cooking experience with various recipes from around the world.

1. Our Mission:
   - To empower users with the tools and knowledge they need to cook delicious meals.
   - To curate a wide range of recipes that cater to different tastes and dietary preferences.

2. Our Vision:
   - To become the leading recipe discovery platform, with a community of passionate cooks.
   - To continually update and expand our recipe collection, integrating user feedback and suggestions.

3. How It Works:
   - Browse our recipe categories or search for your favorite dishes.
   - Save your favorite recipes and share them with your friends and family.
   - Follow detailed step-by-step instructions for each recipe, with images and helpful tips.

4. Join Our Community:
   - Share your own recipes with others and connect with fellow cooking enthusiasts.
   - Follow us on social media to stay updated on the latest recipes and tips.

We hope our app inspires you to try new recipes and brings joy to your cooking experience. Thank you for using our app!

For any inquiries or suggestions, contact us at support@example.com.
              ''',
              style: TextStyle(
                fontSize: 16.0,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



class ThemeChangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Change"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Dark Mode",
              style: TextStyle(fontSize: 16),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);  // Update theme
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '''
This Privacy Policy describes how your personal information is collected, used, and shared when you use this app.

1. Information We Collect:
   - Personal Information: Name, email address, etc., provided during registration.
   - Usage Information: Data about how you interact with the app.
   - Device Information: Information about your device and OS.

2. How We Use Your Information:
   - To improve the app experience.
   - To communicate with you about updates and features.
   - To ensure data security and prevent misuse.

3. Sharing Your Information:
   - We do not sell your information to third parties.
   - Information may be shared with trusted partners to enhance functionality.

4. Data Security:
   - We use encryption and secure storage to protect your data.

5. Your Rights:
   - You have the right to access, update, or delete your information at any time.

For more details, contact us at support@example.com.

By using this app, you agree to this Privacy Policy.
          ''',
              style: TextStyle(
                fontSize: 16.0,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Section
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text(
                "Email Us",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: GestureDetector(
                onTap: () => _launchUrl('mailto:support@example.com'),
                child: const Text(
                  "support@example.com",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const Divider(),

            // Phone Section
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text(
                "Call Us",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: GestureDetector(
                onTap: () => _launchUrl('tel:+1234567890'),
                child: const Text(
                  "+1 234 567 890",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const Divider(),

            // Discord Section
            ListTile(
              leading: const Icon(Icons.discord),
              title: const Text(
                "Join Us on Discord",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: GestureDetector(
                onTap: () => _launchUrl('https://discord.com/invite/example'),
                child: const Text(
                  "discord.com/invite/example",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const Divider(),

            // Social Media Section
            const Text(
              "Follow Us",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: "Follow us on Instagram",
                  child: IconButton(
                    icon: const Icon(Iconsax.instagram4, color: Colors.pink),
                    onPressed: () => _launchUrl('https://instagram.com/example'),
                  ),
                ),
                Tooltip(
                  message: "Follow us on Facebook",
                  child: IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.blue),
                    onPressed: () => _launchUrl('https://facebook.com/example'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class NotificationHelper {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationHelper() {
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Ensure 'app_icon' exists in res/drawable

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleMealNotifications() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meal_reminders', // Channel ID
      'Meal Reminders', // Channel name
      channelDescription: 'Daily meal notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // Schedule notifications for specific times
    await _scheduleNotification(
      id: 1,
      title: 'Good Morning!',
      body: "Let's create a breakfast masterpiece to start your day fresh!",
      hour: 7,
      minute: 0,
      notificationDetails: notificationDetails,
    );

    await _scheduleNotification(
      id: 2,
      title: 'Lunchtime!',
      body: "Treat yourself to something tasty and energizing!",
      hour: 14,
      minute: 0,
      notificationDetails: notificationDetails,
    );

    await _scheduleNotification(
      id: 3,
      title: 'Dinner Time!',
      body: "Enjoy a delightful meal to end your day perfectly.",
      hour: 19,
      minute: 0,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required NotificationDetails notificationDetails,
  }) async {
    final now = DateTime.now();
    final scheduleTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Adjust if time has already passed for today
    final adjustedScheduleTime = scheduleTime.isBefore(now)
        ? scheduleTime.add(const Duration(days: 1))
        : scheduleTime;

    // Convert to timezone-aware DateTime
    final tzScheduleTime = tz.TZDateTime.from(adjustedScheduleTime, tz.local);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduleTime, // Correct timezone-aware time
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact, // Set the scheduling mode
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Optional but useful
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}


