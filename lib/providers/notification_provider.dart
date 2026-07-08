import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationSettingsState {
  final bool periodReminder;
  final bool ovulationReminder;
  final bool pillReminder;
  final bool symptomReminder;
  final bool dailyCheckIn;
  final int periodReminderDaysBefore;
  final int pillReminderHour;
  final int pillReminderMinute;

  const NotificationSettingsState({
    this.periodReminder = true,
    this.ovulationReminder = true,
    this.pillReminder = true,
    this.symptomReminder = true,
    this.dailyCheckIn = true,
    this.periodReminderDaysBefore = 2,
    this.pillReminderHour = 8,
    this.pillReminderMinute = 0,
  });

  NotificationSettingsState copyWith({
    bool? periodReminder,
    bool? ovulationReminder,
    bool? pillReminder,
    bool? symptomReminder,
    bool? dailyCheckIn,
    int? periodReminderDaysBefore,
    int? pillReminderHour,
    int? pillReminderMinute,
  }) {
    return NotificationSettingsState(
      periodReminder: periodReminder ?? this.periodReminder,
      ovulationReminder: ovulationReminder ?? this.ovulationReminder,
      pillReminder: pillReminder ?? this.pillReminder,
      symptomReminder: symptomReminder ?? this.symptomReminder,
      dailyCheckIn: dailyCheckIn ?? this.dailyCheckIn,
      periodReminderDaysBefore: periodReminderDaysBefore ?? this.periodReminderDaysBefore,
      pillReminderHour: pillReminderHour ?? this.pillReminderHour,
      pillReminderMinute: pillReminderMinute ?? this.pillReminderMinute,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsNotifier() : super(const NotificationSettingsState());

  void togglePeriodReminder() {
    state = state.copyWith(periodReminder: !state.periodReminder);
  }

  void toggleOvulationReminder() {
    state = state.copyWith(ovulationReminder: !state.ovulationReminder);
  }

  void togglePillReminder() {
    state = state.copyWith(pillReminder: !state.pillReminder);
  }

  void toggleSymptomReminder() {
    state = state.copyWith(symptomReminder: !state.symptomReminder);
  }

  void toggleDailyCheckIn() {
    state = state.copyWith(dailyCheckIn: !state.dailyCheckIn);
  }

  void setPillReminderTime(int hour, int minute) {
    state = state.copyWith(pillReminderHour: hour, pillReminderMinute: minute);
  }

  void setPeriodReminderDays(int days) {
    state = state.copyWith(periodReminderDaysBefore: days);
  }
}

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> schedulePeriodReminder({
    required int daysUntil,
    required int daysBefore,
  }) async {
    if (daysUntil > daysBefore) return;

    await _plugin.show(
      0,
      'Peryòd ap vini!',
      'Ou gen $daysUntil jou ankò anvan pwochen peryòd ou. Prepare w!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'period_reminder',
          'Rappel Peryòd',
          channelDescription: 'Rappel pou peryòd',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> scheduleOvulationReminder({
    required int daysUntilOvulation,
  }) async {
    if (daysUntilOvulation > 3 || daysUntilOvulation < 0) return;

    String message;
    if (daysUntilOvulation == 0) {
      message = 'Jodi a se jou ovilasyon ou! Chans gwosè a wo.';
    } else if (daysUntilOvulation == 1) {
      message = 'Demain se jou ovilasyon ou! Fenèt fetil ou kòmanse.';
    } else {
      message = 'Ovilasyon ou ap vini nan $daysUntilOvulation jou.';
    }

    await _plugin.show(
      1,
      'Ovilasyon',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ovulation_reminder',
          'Rappel Ovilasyon',
          channelDescription: 'Rappel pou ovilasyon',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> schedulePillReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      2,
      'Pilil ou!',
      'Ou bliye pran pilil ou jodi a. Pran l oubyen pa bliye!',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pill_reminder',
          'Rappel Pilil',
          channelDescription: 'Rappel pou pran pilil',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleSymptomReminder() async {
    await _plugin.zonedSchedule(
      3,
      'Kijan ou santi w?',
      'Pa bliye anrejistre sentòm ou jodi a!',
      _nextInstanceOfTime(20, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'symptom_reminder',
          'Rappel Sentòm',
          channelDescription: 'Rappel pou anrejistre sentòm',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleDailyCheckIn() async {
    await _plugin.zonedSchedule(
      4,
      'Bonjou!',
      'Kòmanse jou a byen! Chwazi imè ou a.',
      _nextInstanceOfTime(7, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_checkin',
          'Verifikasyon Joualière',
          channelDescription: 'Verifikasyon chak jou',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
