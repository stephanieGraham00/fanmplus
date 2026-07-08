import 'package:firebase_messaging/firebase_messaging.dart';
import '../platform/local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await initializeNotifications();
    final token = await _messaging.getToken();
    if (token != null) {}

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showNotification(notification.hashCode, notification.title ?? '', notification.body ?? '');
    }
  }

  Future<void> showPeriodReminder() async {
    await showNotification(0, '🌸 Period Tracker', 'Time to log your period symptoms!');
  }

  Future<void> showMedicationReminder(String name) async {
    await showNotification(1, '💊 Medication Reminder', 'Time to take $name');
  }

  Future<String?> getToken() => _messaging.getToken();
}
