import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipie_app/Utils/notification_helper.dart';

class NotificationProvider with ChangeNotifier {
  late NotificationHelper _notificationHelper;
  bool _areNotificationsEnabled = true;

  NotificationProvider() {
    _notificationHelper = NotificationHelper();
    _loadNotificationPreference();
  }

  bool get areNotificationsEnabled => _areNotificationsEnabled;

  void _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _areNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }

  void toggleNotifications(bool value) async {
    _areNotificationsEnabled = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);

    if (value) {
      _notificationHelper.showImmediateNotification(
        title: "Notifications Enabled",
        body: "You will now receive notifications for app ratings.",
      );
    } else {
      _notificationHelper.cancelAllNotifications();
    }
  }
}
