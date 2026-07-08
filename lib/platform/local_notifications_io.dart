import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _notifications = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
  await _notifications.initialize(initSettings);
}

Future<void> showNotification(int id, String title, String body) async {
  const details = NotificationDetails(
    android: AndroidNotificationDetails('fanmplus_channel', 'Fanm+ AI', importance: Importance.high),
    iOS: DarwinNotificationDetails(),
  );
  await _notifications.show(id, title, body, details);
}
