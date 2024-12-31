import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  NotificationHelper() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload != null) {
      final Uri url = Uri.parse(payload);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch URL: $url");
      }
    }
  }

  Future<bool> _isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notificationsEnabled') ?? true;
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    if (await _isNotificationsEnabled()) {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'notification_alert',
        'Notification Alert',
        channelDescription: 'For Notification Alert',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await _notification.show(
        0,
        title,
        body,
        notificationDetails,
      );
    }
  }

  Future<void> scheduleDishReminderNotification() async {
    if (await _isNotificationsEnabled()) {
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'dish_reminder',
        'Dish Reminder',
        channelDescription: 'Reminder to try another dish after some time',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      // Schedule notification for 7 hours later
      await _notification.zonedSchedule(
        1, // Notification ID
        'Feeling hungry?', // Title
        "Let's make another dish!", // Body
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 7)),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> showRateAppNotification() async {
    if (await _isNotificationsEnabled()) {
      const String appStoreUrl = "https://yourappstorelink.com";

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'rate_app',
        'Rate App Reminder',
        channelDescription: 'Notification to encourage app rating',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await _notification.show(
        0, // Notification ID
        'How was the dish?', // Title
        'Consider Rating our app!', // Body
        notificationDetails,
        payload: appStoreUrl, // Attach the URL
      );
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notification.cancelAll();
  }
}
